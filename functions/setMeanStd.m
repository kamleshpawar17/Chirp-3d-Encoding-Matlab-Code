function [y] = setMeanStd(x, mu, sigma, varargin)
% SETMEANSTD 
% This function sets the mean of the x to mu and standard deviation to
% sigma
% 
% [y] = SETMEANSTD(x, mu, sigma, mask) Explain usage here
% Input:
%
% x : Input matrix
% mu : required mean
% sigma: required standard deviation
% mask : logical variable with 1's at the location which will be considered valid for the
% compuation of statistics. ex: mask can be location of the foreground in image.
%
% Output:
% y : ouput matrix with mean mu and std sigma
%
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% Author: Kamlesh Pawar 
% Date: 2017/08/12 22:41:27 
% Revision: 0.1 $
% Institute: Monash Biomedical Imaging, Monash University, Australia, 2017

nVarargs = length(varargin);
if ((nVarargs>0) & (varargin{1} == 'mask'))
    maskFG = varargin{2};
    y = (x-mean(x(maskFG)))/std(x(maskFG)); %% zero mean and unity std
else
    y = (x-mean(x(:)))/std(x(:)); %% zero mean and unity std
end
y = sigma*y + mu; %% mu mean and sigma std

if ((nVarargs>0) & (varargin{1} == 'mask'))
    y(~maskFG) = 0.0;
end

end
