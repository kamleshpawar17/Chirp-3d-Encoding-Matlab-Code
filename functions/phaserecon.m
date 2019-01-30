function [pha, swi_n, swi_p, mag] = phaserecon(kimg,kimgsos,a,intpl,thr)
% -------------------------------------------
% Usage: calculate phase images from complex inputs
% Inputs: 
%        kimg -- reconstructed kspace signals
%        kimgsos -- sos of square on complex images
%        a    -- gaussian filter size 0 to 20, 10 is good balance
%        intpl -- interplation factor
%        thr -- thresholding: 0 no thresholding
%                             0.05 a good choice
% Outputs
%        pha -- phase images
%        mag -- magnatitue images
%        swi -- phase weighted magnatitue images
%
% Zhaolin Chen @ Howard Florey Institute
% log            12-05-09 SWI part fixed 
% -------------------------------------------


[Nfe,Npe] = size(kimg);

% creat a Gaussina LPF
win = gausswin(Nfe,a)*gausswin(Npe,a)';

% creat a rectangular LPF
% win = zeros(Nfe,Npe);
% L = 32;W = 32;
% win(round(Nfe/2-L/2):round(Nfe/2+L/2-1),round(Npe/2-W/2):round(Npe/2+W/2-1)) = ones(L,W);


% creat a Kaiser LPF
%win = hann(Nfe)*hann(Npe)';
%win = kaiser(Nfe,a)*kaiser(Npe,a)';

[xx,yy] = find(kimg == max(kimg(:)));
win = circshift(win,[xx,yy]-[floor(Nfe/2), floor(Npe/2)]);



img = fftshift(fft2(kimg,intpl*Nfe,intpl*Npe));
imgsos = fftshift(fft2(kimgsos,intpl*Nfe,intpl*Npe));
img_lpf = fftshift(fft2(kimg.*win,intpl*Nfe,intpl*Npe));


img_hpf = img ./ img_lpf;

mag = abs(img);

thd = (thr/sqrt(sqrt(intpl)))*max(abs(imgsos(:))); 


pha = angle(img_hpf);


if (thr ~= 0)
   for i = 1:intpl*Nfe
       for j = 1:intpl*Npe
           if (abs(imgsos(i,j)) <= thd)
              pha(i,j) = pha(i,j)/10;
           end
       end
   end
end

%mag = sqrt(mag);


phasemask_n = (pha+pi)./pi;

[x] = find(pha>=0);
phasemask_n(x) = 1;

phasemask_p = (pi-pha)./pi;

[x] = find(pha<=0);
phasemask_p(x) = 1;

swi_n = phasemask_n.^3.*mag;
swi_p = phasemask_p.^3.*mag;

