clc ; clearvars;
close  all;

%%% ----- GLobal Parameters ----- %%%%
satThrshld = 99.5; smapFact = 1.5;
Acc= 5; % Acceleration Factor = M/N 
N = 256; 
M = ceil(N/Acc);

%%% ------ Encoding Matrix ------ %%%%
F = conj(generate_chirp(N, 0.01227));
load('./data/mask/optCmask5_1.mat')
r = find(mask(:,1)==1);
Fu = F(r,:);

%%% ------ Load fully sampled k-space data ------ %%%
load('./data/Prospective/ksDataSmaps_C_Invivo_Mprage_prospective_Acc1_subj2.mat')
ksDataFull = ksData./max(abs(ksData(:)));
%%% ------ Load under sampled k-space data ------ %%%
load('./data/Prospective/ksDataSmaps_C_Invivo_Mprage_prospective_Acc5_subj2.mat');
[PE,FE,CH] = size(ksData);
S = SCalib;
ksDataUnd = ksData./max(abs(ksData(:)));

%%% ------ Compute Adaptive Coil Combined Image ----- %%%
data =zeros(M*CH, FE);
I = zeros(PE,FE);
for k = 1:CH
    data((k-1)*M+1:k*M,:) = ksDataUnd(r,:,k);
    I = I + (F'*ksDataFull(:,:,k)).*conj(S(:,:,k));
end
I = (I).*((sum(abs(S),3)).^smapFact);
figure; 
subplot(1,2,1); imshow(rot90(angle(I),1),[]); title('Phase fully sampled Image')
subplot(1,2,2); imshow(rot90(saturate2xpercentile(abs(I),satThrshld),1),[])
title('Magnitude fully sampled Image')

%%% ------ Sampling Operator ------ %%%
A = @(x) FT_coil(x, S, Fu);
A_= @(x) A_FT_coil (x, S, Fu);
FT = A_operator(@(x) A(x), @(x) A_(x));

%%% ------ L1 Recon Parameters ------ %%% 
lambda = 0.006;
TVWeight = lambda; 	% Weight for TV penalty %%% 0.001 for GRE and 0.004 for MPRAGE
xfmWeight = lambda;	% Weight for Transform L1 penalty  %%% 0.001 for GRE and 0.004 for MPRAGE
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
	res = fnlCg(res, param, 1);
	im_res = XFM'*res;
    Idisp = saturate2xpercentile(abs(im_res).*((sum(abs(S),3)).^smapFact),satThrshld);
    
    subplot(2,2,1);imshow(rot90(log(abs(XFM*im_dc)), 1),[]); drawnow
    subplot(2,2,2);imshow(rot90(log(abs(res)), 1),[]); drawnow
    subplot(2,2,3);imshow(rot90(abs(im_dc), 1),[]); drawnow
    subplot(2,2,4);imshow(rot90(Idisp, 1),[]); drawnow
end
toc
I = (I)./max(abs(I(:)));
Ir = (im_res).*((sum(abs(S),3)).^smapFact);
Ir = (Ir)./max(abs(Ir(:)));

figure; 
subplot(2,2,1); imshow(rot90(saturate2xpercentile(abs(I),satThrshld),1),[]);title('Fully Sampled Magnitude Image Fourier'); 
subplot(2,2,2); imshow(rot90(angle(I),1),[]);title('Fully Sampled Phase Image Fourier'); 
subplot(2,2,3); imshow(rot90(saturate2xpercentile(abs(Ir),satThrshld),1),[]);title('Reconstructed Magnitude Image Fourier'); 
subplot(2,2,4); imshow(rot90(angle(Ir),1),[]);title('Reconstructed Phase Image Fourier'); 







