function [y] = hdf5_to_cplxmat(fname)
%CPLX2MATHDF5 Summary of this function goes here
% 
% [OUTPUTARGS] = CPLX2MATHDF5(INPUTARGS) Explain usage here
% 
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% Author: Kamlesh Pawar 
% Date: 2018/10/18 13:42:23 
% Revision: 0.1 $
% Institute: Monash Biomedical Imaging, Monash University, Australia, 2018

    fprintf('Reading file...\n');
    IMatR = h5read(fname, '/real');
    IMatI = h5read(fname, '/imag');
    y = double(IMatR + 1i*IMatI);
    fprintf('Done Reading file\n');
end
