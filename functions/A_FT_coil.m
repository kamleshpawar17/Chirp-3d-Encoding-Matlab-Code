function [Ir] = A_FT_coil(ks, b1, F)
%%%% Takes concated k-space (ks) of ch*m x n and returen Image
[r, c, ch] = size(b1);
r_ch = size(ks,1);
Ir =zeros(r,c);

    for k = 1:ch
%         Ir = Ir + (F'*ks((k-1)*(r_ch/ch)+1:k*(r_ch/ch),:,:)).*conj(b1(:,:,k))./abs(b1(:,:,k));
        Ir = Ir + (F'*ks((k-1)*(r_ch/ch)+1:k*(r_ch/ch),:,:)).*conj(b1(:,:,k));
    end
end