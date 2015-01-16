function [myEq,myCoeff]=prAiryFKOn(n,varargin)
% prAiryFKOn builds a string defining the sum of (n) oscillators of the
% equation presented in prAiryFKO.m.
%   Inputs:
%       n: Number of oscillators to use [unitless] {scalar expected}
%   Optional Inputs:
%       'coupleFKO':   'false':  (default) allows indpendent bandgap energy term,
%                                broadening parameter term, and phase term.
%                      'true': locks all bandgap energy terms, broadening
%                               parameter terms, and phase terms as one
%                               parameter for all pfAiryFKO oscillators;
%                               still requires a value in initial vector
%                               and in type vector for both FKO
%                               oscillators.

%   Outputs:
%       myEq: Equation to use in building a fittype {string}
%       myCoeff: List of parameter names used in myEq {vector}
%
%  This function file was written in MATLAB 2014a,
%  and is part of the project: photoreflectance.
% 
%  Copyright 2014 Stephen J. Polly, RIT; Andrew B. Sindermann, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'coupleFKO','false');
    addOptional(p,'iteration',0);
    parse(p,varargin{:});
    
    myEq='';
    myCoeff={};
    if p.Results.iteration > 0 && n > 1
        err = MException('n:OutOfRange', ...
            'If ''iteration'' is specified, n must equal 1');
        throw(err)
    end
    
    for i=1:n
        if p.Results.iteration == 0
            nx=num2str(i,'%02d');
        else
            nx=num2str(p.Results.iteration,'%02d');
        end
        hOFKOx=strcat('hOFKO',nx);
        AFKOx=strcat('AFKO',nx);
        %phix=strcat('phi',nx);
        %gammaFKOx=strcat('gammaFKO',nx);
        %The Coefficient vector is built differently depending on if the 
        %energy term and broadening term are fixed or not. If energy and
        %broadening are fixed, EnFKO00 and gammaFKO00 are the only 
        %energy parameter and broadening parameter, which are used in each 
        %function call.
        %Otherwise they are enumerated as the rest of the parameters.
        if strcmp(p.Results.coupleFKO, 'true') && (i > 1 ... 
            || (p.Results.iteration > 1))
            EnFKOx='EnFKO00';
            gammaFKOx='gammaFKO00';
            phix='phi00';
            myCoeff=horzcat(myCoeff, {hOFKOx, AFKOx});
            %myCoeff=horzcat(myCoeff, {hOFKOx, phix, AFKOx});
            %myCoeff=horzcat(myCoeff, {gammaFKOx, hOFKOx, phix, AFKOx});
        else
            if strcmp(p.Results.coupleFKO, 'true')...
                && (p.Results.iteration <= 1)
                EnFKOx='EnFKO00';
                gammaFKOx='gammaFKO00';
                phix='phi00';
            else
                EnFKOx=strcat('EnFKO',nx);
                gammaFKOx=strcat('gammaFKO',nx);
                phix=strcat('phi',nx);
            end
            myCoeff=horzcat(myCoeff, {EnFKOx, gammaFKOx, hOFKOx, phix, AFKOx});
        end
        myEq=strcat(myEq, 'prAiryFKO(x, ', EnFKOx, ', ', gammaFKOx, ', ',...
            hOFKOx, ', ', phix, ', ', AFKOx, ') +');
    end
    myEq=myEq(1:end-2); %remove trailing ' +'
end