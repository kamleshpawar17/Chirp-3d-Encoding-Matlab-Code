function [ks] = FT_coil(I, b1, Fu)
%%%% Takes image and returns concated k-space of ch*m x n.
    [~, c, ch] = size(b1);
    m = size(Fu,1);
    ks = zeros(ch*m,c);
    for k = 1:ch
%        ks = [ks; Fu*(b1(:,:,k).*I)];
       ks(m*(k-1)+1:m*k,:) = Fu*(b1(:,:,k).*I);
    end
end