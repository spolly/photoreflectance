function f=prFDFF(E,En,gamma,theta,A)
% prFDFF returns the first-derivative Gaussian lineshape for confined
% carrier photoreflectance:
%   Inputs:
%        E: Energy [eV] {vector expected}
%       En: Oscillator energy [eV] {scalar expected}
%    gamma: Broadning factor [eV] {scalar expected}
%    theta: Phase term [radians] {scalar expected}
%        A: Amplitude factor [unitless] {scalar expected}
%   Outputs:
%        f: Output delR/R [proportinal to J^3] {vector}
%
%   The formula is taken from eq. 7a, page 3810 of [1].
%
%   This was written in MATLAB R2013a, and requires the free/open-source 
%   C++ version of erfi(): Faddeeva_erfi(), written by S. G. Johnson, which 
%   can be found, along with instructions on compiling, at:
%   http://ab-initio.mit.edu/Faddeeva
%
% [1]Y. S. Huang, H. Qiang, F. H. Pollak, J. Lee, and B. Elman, 
%  “Electroreflectance study of a symmetrically coupled GaAs/Ga0.77Al0.23As 
%  double quantum well system,” Journal of Applied Physics, vol. 70, no. 7,
%  p. 3808, 10/1/1991 1991. DOI: 10.1063/1.349184
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    % Begin with equation 6b [1].
    a0=(E-En)./gamma; 
    % Compute eq. 3d [1], psi(1, 1/2, -y^2/2), the confluent hypergeometric 
    % function (see comments in chfPR.m).
    a1=prCHF(a0);
    % Then: eq. 3e [1].
    a2=-(pi/2)^(1/2).*a0.*exp(-(a0.^2./2));
    % Finally, compute one element j of eq. 7a [1].
    f=A.*(sin(theta).*a1+cos(theta).*a2);
end