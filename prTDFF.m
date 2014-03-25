function f=prTDFF(x,Eg,gamma,hO,theta,m,A)
% prTDFF returns the calculated low-field deltaR/R based on several inputs.
%   Inputs:
%        x: Energy [eV] {vector expected}
%       Eg: Oscillator energy [eV] {scalar expected}
%    gamma: Broadning factor [eV] {scalar expected}
%       hO: Electro-optical energy [eV] {scalar expected}
%    theta: Phase term [radians] {scalar expected}
%        m: Exponent (from dimentionality of CPs) [unitless] 
%            {scalar expected}
%        A: Amplitude factor [unitless] {scalar expected}
%   Outputs:
%        f: delR/R [proportinal to eV^3] {vector}
%
%   If all values in [eV] are replaced with [J], the function is still
%   valid, though that may only hold for this file and not the overall 
%   program. The formula is taken from eq. 4a, page 284 of [1].
%
%  [1]F. H. Pollak and H. Shen, "Modulation spectroscopy of semiconductors: 
%  bulk/thin film, microstructures, surfaces/interfaces and devices,"
%  Materials Science and Engineering: R: Reports, vol. 10, no. 7-8, 
%  pp. xv-374, Oct. 1993. DOI: 10.1016/0927-796X(93)90004-M
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoreflectance.
% 
%  Copyright 2014, Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.
%
    f=((hO).^3).*real(A.*exp(1i.*theta).*(x-Eg+1i.*gamma).^-m);
end

