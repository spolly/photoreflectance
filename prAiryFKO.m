function f=prAiryFKO(E,Eg,gamma,hO,phi,A)
% prAiryFKO returns the calculated mid-field deltaR/R based on the 
% following inputs:
%   Inputs:
%        E: Energy [eV] {vector expected}
%       Eg: Oscillator energy [eV] {scalar expected}
%    gamma: Broadning factor [eV] {scalar expected}
%       hO: Electro-optical energy [eV] {scalar expected}
%    phi: Phase term [radians] {scalar expected}
%        A: Amplitude factor [unitless] {scalar expected}
%   Outputs:
%        f: delR/R [unitless] {vector}
%
%   The formula is taken from eq. 10, page 3093 of [1].
%
%   [1]D.J. Hall, T.J.C. Hosea, D. Lancefield, J. Appl. Phys. 82 (1997) 3092
%       DOI: 10.1063/1.366149
% 
%  This function file was written in MATLAB 2014a,
%  and is part of the project: photoreflectance.
% 
%  Copyright 2014 Stephen J. Polly, RIT; Andrew B. Sindermann, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    z = ((Eg-E+1i*gamma)./hO);
    Z = z.*exp(-1i*(2*pi/3));

    H = 2.*pi.*(exp(-1i*pi/3).*airy(1,z).*airy(1,Z)+Z.*airy(0,z).*airy(0,Z))+1i*(z).^(1/2);
    %H = (4*z).^(-1).*exp((4/3)*z.^(3/2)) - 1i/32*z.^(-5/2); %Asymptotic Approximation

    L = A.*exp(1i*phi).*((E - 1i*gamma).^(-2));

    f = real(L.*H);
end