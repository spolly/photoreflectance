function [myEq,myCoeff]=prFDFFn(n,varargin)
% prFDFFn builds a string defining the sum of (n) oscillators of the
% equation presented in prfDFF.m.
%   Inputs:
%       n: Number of oscillators to use [unitless] {scalar expected}
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%   Outputs:
%       myEq: Equation to use in building a fittype {string}
%       myCoeff: List of parameter names used in myEq {vector}
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoreflectance.
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'couplePhase','false');
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
        EnFx=strcat('EnF',nx);
        gammaFx=strcat('gammaF',nx);
        AFx=strcat('AF',nx);
        %The Coefficient vector is built differently depending on if the 
        %phase term is fixed or not. If phase is fixed, theta1 is the only 
        %phase parameter, which is used in each function call. Otherwise
        %they are enumerated as the rest of the parameters.
        if strcmp(p.Results.couplePhase, 'true') && (i > 1 ... 
            || (p.Results.iteration > 1))
            thetaFx='thetaF00';
            myCoeff=horzcat(myCoeff, {EnFx, gammaFx, AFx});
        else
            if strcmp(p.Results.couplePhase, 'true')...
                && (p.Results.iteration <= 1)
                thetaFx='thetaF00';
            else
                thetaFx=strcat('thetaF',nx);
            end
            myCoeff=horzcat(myCoeff, {EnFx, gammaFx, thetaFx, AFx});
        end
        myEq=strcat(myEq, 'prFDFF(x, ', EnFx, ',', gammaFx, ',',...
            thetaFx, ',', AFx, ') +');
    end
    %remove trailing ' +'
    myEq=myEq(1:end-2);
end