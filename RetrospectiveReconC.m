clc ; clearvars;
close  all;

%%% ----- GLobal Parameters ----- %%%%
satThrshld = 99.0; smapFact = 1.;
Acc= 5; % Acceleration Factor = M/N 
N = 256; 
M = ceil(N/Acc);

%%% ------ Encoding Matrix ------ %%%%
F = conj(generate_chirp(N, 0.01227));
load('./data/mask/optCmask5_1.mat')
r = find(mask(:,1)==1);
Fu = F(r,:);

%%% ------ Load k-space data ------ %%%
load('./data/Retrospective/RetroksDataSmapsMprageSag_C_1.mat')
S = SCalib;
[PE,FE,CH] = size(ksData);
ksData = ksData./max(abs(ksData(:)));

%%% ------ Compute Adaptive Coil Combined Image ----- %%%
data =zeros(M*CH, FE);
I = zeros(PE,FE);
for k = 1:CH
    data((k-1)*M+1:k*M,:) = ksData(r,:,k);
    I = I + (F'*ksData(:,:,k)).*conj(S(:,:,k));
end
I = (I).*((sum(abs(S),3)).^smapFact);
figure; 
subplot(1,2,1); imshow(rot90(angle(I),1),[]); title('Phase Original Image')
subplot(1,2,2); imshow(rot90(saturate2xpercentile(abs(I),satThrshld),1),[])
title('Magnitude Original Image')

%%% ------ Sampling Operator ------ %%%
A = @(x) FT_coil(x, S, Fu);
A_= @(x) A_FT_coil (x, S, Fu);
FT = A_operator(@(x) A(x), @(x) A_(x));

%%% ------ L1 Recon Parameters ------ %%% 
TVWeight = 0.006; 	% Weight for TV penalty %%% 0.004 for GRE and 0.006 for MPRAGE
xfmWeight = 0.006;	% Weight for Transform L1 penalty  %%% 0.004 for GRE and 0.006 for MPRAGE
Itnlim = 50;		% Number of iterations
%%% ------ Scale data ------ %%%
im_dc = FT'*(data);
data = data/max(abs(im_dc(:)));
im_dc = im_dc/max(abs(im_dc(:)));
figure; 
subplot(1,2,1); imshow(rot90(angle(im_dc),1),[]); title('Phase Undersampled Image')
subplot(1,2,2); imshow(rot90(saturate2xpercentile(abs(im_dc),satThrshld),1),[])
title('Magnitude Undersampled Image')

%%% ------ Transform Operator ------ %%%
wav = daubcqf(4);
W1 = @(x) idwtcplx(x,wav);
WT1 = @(x) dwtcplx(x,wav);
XFM = A_operator(@(x) WT1(x), @(x) W1(x));

%%% ------ initialize Parameters for reconstruction ------ %
param = init;
param.FT = FT;
param.XFM = XFM;
param.TV = TVOP;
param.data = data;
param.TVWeight =TVWeight;     % TV penalty 
param.xfmWeight = xfmWeight;  % L1 wavelet penalty
param.Itnlim = Itnlim;
res = XFM*im_dc;
figure; 
subplot(2,2,1);imshow(rot90(log(abs(XFM*im_dc)), 1),[]); drawnow
subplot(2,2,2);imshow(rot90(log(abs(res)), 1),[]); drawnow
subplot(2,2,3);imshow(rot90(abs(im_dc), 1),[]); drawnow
subplot(2,2,4);imshow(rot90((abs(im_dc).*((sum(abs(S),3)).^2)), 1),[]); drawnow

%%% ----- Iterations ------ %%%
tic
for n1=1:5
    fprintf('\nIteration: %d\n', n1);
	res = fnlCg(res,param, 1);
	im_res = XFM'*res;
    Idisp = saturate2xpercentile(abs(im_res).*((sum(abs(S),3)).^smapFact),satThrshld);

    subplot(2,2,1);imshow(rot90(log(abs(XFM*im_dc)), 1),[]); drawnow
    subplot(2,2,2);imshow(rot90(log(abs(res)), 1),[]); drawnow
    subplot(2,2,3);imshow(rot90(abs(im_dc), 1),[]); drawnow
    subplot(2,2,4);imshow(rot90(Idisp, 1),[]); drawnow
end
toc
Ir = abs(im_res).*((sum(abs(S),3)).^smapFact);
Ir = abs(Ir)./max(abs(Ir(:)));
I = abs(I)./max(abs(I(:)));
figure; 
subplot(2,2,1); imshow(rot90(saturate2xpercentile(abs(I),satThrshld),1),[]);title('Orignal Image chirp'); 
subplot(2,2,2); imshow(rot90(saturate2xpercentile(abs(Ir),satThrshld),1),[]);title('Reconstructed Image Chirp'); 
subplot(2,2,3); imshow(6*rot90(abs(I-Ir),1),[0 1]);title('Difference Image Chirp');

load ('./data/mask/maskFG_Mprage.mat')
ssIndx = ssim(Ir.*maskFG, I.*maskFG);
ErrRel = relative_error(Ir.*maskFG, I.*maskFG);
fprintf('SSMI    : %f\nRel Err : %f\n', ssIndx, ErrRel)


