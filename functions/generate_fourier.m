function [F]= generate_fourier(N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [F]= generate_fourier(N)
% Generate disrete fourier transform matrix of size NxN
% Author: Kamlesh Pawar
% Date : 22/03/2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F=zeros(N,N);
% for n=1:N
%     for k=1:N
%         F(n,k)=exp(((-2*pi*(n-1)*(k-1))/N)*1i);
%     end
% end
% F=F*(1/sqrt(N));
% F = fftshift(F);
for n=1:N
   F(n,:)=exp(((-2*pi*(n-1-N/2)./N*(-N/2:N/2-1)))*1i);
end
F=F*(1/sqrt(N));
end