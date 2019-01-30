function [y] = saturate2xpercentile(x, perctl)
% This function saturates the value above perctl percentage of the max
%
%
% [y] = SATURATE2XPERCENTILE(x, perctl) Explain usage here
% 
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% Author: Kamlesh Pawar 
% Date: 2017/10/16 12:08:13 
% Revision: 0.1 $
% Institute: Monash Biomedical Imaging, Monash University, Australia, 2017

    thrshldU = prctile(x(:),perctl);
    y = x;
    y(x>thrshldU) = thrshldU;
end
