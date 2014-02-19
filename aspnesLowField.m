function y=aspnesLowField(E,Eg,gamma,hO,theta,m,A)
% aspnesLowField returns the low-field deltaR/R signal based on the 
% following inputs:
%     E: Energy [J] {vector expected
%    Eg: Bandgap Energy [J] {scalar expected}
% gamma: Broadning factor [J] {scalar expected}
%    hO: Electro-optical energy [J] {scalar expected}
% theta: Phase term [radians] {scalar expected}
%     m: Exponent (from dimentionality CPs) [unitless] {scalar expected}
%     A: Amplitude factor [unitless] {scalar expected}
%
%     y: Output delR/R [proportinal to J^3] {vector}
%
%   The formula is taken from eq. 4a, page 284 of [1].
%
%   [1]F. H. Pollak and H. Shen, "Modulation spectroscopy of semiconductors: 
%   bulk/thin film, microstructures, surfaces/interfaces and devices,"
%   Materials Science and Engineering: R: Reports, vol. 10, no. 7-8, 
%   pp. xv-374, Oct. 1993. DOI: 10.1016/0927-796X(93)90004-M
% 
%   Copyright 2014 Stephen J. Polly, RIT
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License v3.
%
y=((hO).^3).*real(A.*exp(1i.*theta).*(E-Eg+1i.*gamma).^-m);
end

