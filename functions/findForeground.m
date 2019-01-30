function [y] = findForeground(x, thrshld, filterSize)
%FINDFOREGROUND Summary of this function goes here
% 
% [OUTPUTARGS] = FINDFOREGROUND(INPUTARGS) Explain usage here
% 
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% Author: Kamlesh Pawar 
% Date: 2018/01/08 17:48:06 
% Revision: 0.1 $
% Institute: Monash Biomedical Imaging, Monash University, Australia, 2018
    maskFG = zeros(size(x));
    maskFG(x>thrshld) = 1;
    SE = strel('cube',filterSize);
%     SE1 = strel('cube',filterSize/2);
%     maskFG = imdilate(maskFG,SE);
%     maskFG = imerode(maskFG,SE);
%     y = imerode(maskFG,SE1);
    y = imclose(maskFG,SE);
end
