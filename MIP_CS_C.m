clc; clear
% close all
scale = 300;

% --- Load CS Image Data ---- %
load('./data/Swi/CS_Recon_Acc3_C.mat')
I = hdf5_to_cplxmat('./data/Swi/Image_Chirp.h5');
nstart = 140; nblck = 20;
I = I(:, nstart:nstart+nblck-1, :, :);
I = permute(I, [1, 3, 2]);
% Irec_C = Irec_C(:, :, nstart:nstart+nblck-1);

Irec_C = Irec_C/max(abs(Irec_C(:)));
I = I/max(abs(I(:)));

% ---- Compute SWI and MIP ---- %
[~, ~, swi_n_cs, ~] = SWI_Recon_3D(Irec_C);
I_n_cs = min(swi_n_cs,[],3);

[~, ~, swi_n, ~] = SWI_Recon_3D(I);
I_n = min(swi_n,[],3);
figure; 
subplot(2,2,1); imshow(I_n_cs,[],'InitialMagnification', scale); title('CS Chirp MIP negative')
subplot(2,2,2); imshow(I_n,[],'InitialMagnification', scale); title('Chirp MIP negative')
I_n = setMeanStd(I_n, 0.5, 1/6.0);
I_n_cs = setMeanStd(I_n_cs, 0.5, 1/6.0);
I_err = abs(I_n-I_n_cs);
subplot(2,2,3); imshow(4*I_err,[0 1],'InitialMagnification', scale); title('Difference Image')


fprintf('SSIM: %f \n', ssim(I_n, I_n_cs))
fprintf('MSE: %f \n', immse(I_n, I_n_cs))
fprintf('Relative Error: %f \n', relative_error(I_n, I_n_cs))

function [pha, mag, swi_n, swi_p] = SWI_Recon_3D(I)
% x: 3d input image PE x FE x SL
    [PE, FE, SL] = size(I);
    kIsos = ifftshift(ifft2(fftshift(abs(I))));
    kImg = ifftshift(ifft2(fftshift(I)));
    pha = zeros(PE, FE, SL);
    mag = zeros(PE, FE, SL);
    swi_n = zeros(PE, FE, SL);
    swi_p = zeros(PE, FE, SL);
    for k = 1:SL
        [pha(:,:,k), mag(:,:,k), swi_n(:,:,k), swi_p(:,:,k)] = phaserecon(kImg(:,:,k),kIsos(:,:,k),5,1,0.0);
    end
end



