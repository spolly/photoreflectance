function [myEq,myCoeff]=prTDFFn(n,varargin)
% prTDFFn builds a string defining the sum of (n) oscillators of the
% equation presented in prTDFF.m.
%   Inputs:
%       n: Number of oscillators to use [unitless] {scalar expected}
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%       'fixM': 'true': (default) locks the exponent 'm' as 2.5, typical 
%                       for a three dimentional critical point.
%               'false': allows independent 'm' term for each oscillator.
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
    addOptional(p,'fixM','true');
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
        hOTx=strcat('hOT',nx);
        ATx=strcat('AT',nx);
        EnTx=strcat('EnT',nx);
        gammaTx=strcat('gammaT',nx);
        %The Coefficient vector is built differently depending on what 
        %(from phase and m terms) are fixed. If phase is fixed, theta1 is 
        %the only phase parameter, which is used in each function call. 
        %Otherwise they are enumerated as the rest of the parameters. If 
        %m is fixed, it is simply set to 2.5 and not included as a 
        %parameter at all.
        if strcmp(p.Results.fixM, 'true')
            mTx='2.5';
             if strcmp(p.Results.couplePhase, 'true') && (i > 1 ... 
                || (p.Results.iteration > 1))
                thetaTx='thetaT00';
                myCoeff=horzcat(myCoeff, {EnTx, gammaTx, hOTx, ATx});
             else
                if strcmp(p.Results.couplePhase, 'true')...
                    && (p.Results.iteration <= 1)
                    thetaTx='thetaT00';
                else
                    thetaTx=strcat('thetaT',nx);
                end
                myCoeff=horzcat(myCoeff, {EnTx, gammaTx, hOTx, thetaTx,...
                    ATx});
            end
        else
            mTx=strcat('mT',nx);
            if strcmp(p.Results.couplePhase, 'true') && (i > 1 ... 
                || (p.Results.iteration > 1))
              thetaTx='thetaT00';
              myCoeff=horzcat(myCoeff, {EnTx, gammaTx, hOTx, mTx, ATx});
            else
                if strcmp(p.Results.couplePhase, 'true')...
                    && (p.Results.iteration <= 1)
                    thetaTx='thetaT00';
                else
                    thetaTx=strcat('thetaT',nx);
                end
              myCoeff=horzcat(myCoeff, {EnTx, gammaTx, hOTx, thetaTx,...
                  mTx, ATx});
            end
        end
        myEq=strcat(myEq, 'prTDFF(x,', EnTx, ',', gammaTx, ',', hOTx,...
            ',', thetaTx, ',', mTx, ',', ATx, ') +'); 
    end
    %remove trailing ' +'
    myEq=myEq(1:end-2); 
end

