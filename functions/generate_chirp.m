function [y] = generate_chirp(n,chirpFact)
%GENERATE_CHIRP Summary of this function goes here
% 
% [y] = GENERATE_CHIRP(n, chirpFact) 
% This function creates chirp encoding matrix of size nxn, with chirping factor of chirpFact
% 
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% Author: Kamlesh Pawar 
% Date: 2017/03/13 13:01:41 
% Revision: 0.1 $
% Institute: Monash Biomedical Imaging, Monash University, Australia, 2017

profileF = generate_fourier(n);
x= -n/2:n/2-1;
delC = chirpFact;
chirpModDiag = exp(1i.*(delC.*x.^2+delC));
chirpMod = diag(chirpModDiag);
y = profileF*chirpMod;

end
