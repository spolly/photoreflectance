function f=prCHF(x)
% prCHF computes psi(1, 1/2, -x^2/2), where psi is the confluent 
% hypergeometric function. This precise function definition is difficult to
% calculate in MATLAB without invoking the symbolic toolbox, which
% considerably increases computation time (~4 orders of magnitude larger 
% than this method). An alternative form was determined with WolframAlpha 
% by searching for: 
%       "confluent hypergeometric function (1, 1/2, -x^2/2)"
% The alternate form makes use of the imaginary error function. While not 
% included in MATLAB (without also invoking the symbolic toolbox), a 
% free/open-source C++ version of erfi() was written by S. G. Johnson, and 
% can be found at:
% http://ab-initio.mit.edu/Faddeeva 
% Instructions for compiling it in MATLAB can also be found there.
%
% This particular function, psi(1, 1/2, -x^2/2), was taken from equation 3d 
% of [1].
%
% [1]Y. S. Huang, H. Qiang, F. H. Pollak, J. Lee, and B. Elman, 
%  “Electroreflectance study of a symmetrically coupled GaAs/Ga0.77Al0.23As 
%  double quantum well system,” Journal of Applied Physics, vol. 70, no. 7,
%  p. 3808, 10/1/1991 1991. DOI: 10.1063/1.349184
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoreflectance.
%
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    %prCHF(x) would return NaN or InF if x < -37, x > 37, or x = 0 due to 
    %Faddeeva_erfi(x/sqrt(2)) returning Inf. The modification to x here
    %prevents this from happening, and is of negligible consequence to the
    %functional form. For 0 < x <= 1e-13, Faddeeva_erfi(x) produces a 
    %result equal to or less than its nominal tolerance for  
    %Faddeeva_erfi(0) = 0, but prevents the rest of the function from 
    %producing NaN.
    x(x<-37)=-37;
    x(x>37)=37;
    x(x==0)=1e-13;

    a1=(1-(sqrt(-x).*Faddeeva_erfi(x./sqrt(2)))./(sqrt(x)));
    a2=((2*sqrt(2).*exp((x.^2)/2).*sqrt(x))./((-x).^(3/2)));
    a3=(exp(-(x.^2)./2).*sqrt(-x).*sqrt(x));

    f=real((a3.*(-2.*sqrt(pi).*a1-a2)./sqrt(2)));

    %The symbolic toolbox code is included here for reference, but as
    %mentioned it takes ~1e4 times as long to run.
    %     % prCHF computes psi(1, 1/2, -x^2/2), the confluent   
    %     % hypergeometric function. This function is difficult in MATLAB, 
    %     % using the form psi=e^(-x^2/2) * exponential integral of 
    %     % (n, -x^2/2) where n = 3/2 computed as an alternative form from 
    %     % WolframAlpha call of:
    %     %     "confluent hypergeometric function (1, 1/2, -x^2/2)"
    %     x(x<-37)=-37;
    %     x(x>37)=37;
    %     x(x==0)=1e-13;
    %     xS=sym(x);
    %     a1=exp(-(x.^2./2));
    %     a2=double(expint(3/2,-(xS.^2)/2));
    %     f=real(a1.*a2);
end