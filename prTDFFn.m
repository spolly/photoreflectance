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
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'couplePhase','false');
    addOptional(p,'fixM','true');
    parse(p,varargin{:});
    
    myEq='';
    myCoeff={};
    for i=1:n
        nx=num2str(i);
        hOx=strcat('hO',nx);
        Ax=strcat('A',nx);
        Egx=strcat('Eg',nx);
        gammax=strcat('gamma',nx);
        %The Coefficient vector is built differently depending on what 
        %(from phase and m terms) are fixed. If phase is fixed, theta1 is 
        %the only phase parameter, which is used in each function call. If 
        %m is fixed, it is simply set to 2.5 and not included as a 
        %parameter at all.
        if strcmp(p.Results.fixM, 'true')
            mx='2.5';
            if strcmp(p.Results.couplePhase, 'true') && i > 1
              thetax=strcat('theta','1');
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, Ax});
            elseif strcmp(p.Results.couplePhase, 'true')
              thetax=strcat('theta','1');
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, thetax, Ax});
            else
              thetax=strcat('theta',nx);
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, thetax, Ax});
            end
        else
            mx=strcat('m',nx);
            if strcmp(p.Results.couplePhase, 'true') && i > 1
              thetax=strcat('theta','1');
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, mx, Ax});
            elseif strcmp(p.Results.couplePhase, 'true')
              thetax=strcat('theta','1');
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, thetax, mx, Ax});
            else
              thetax=strcat('theta',nx);
              myCoeff=horzcat(myCoeff, {Egx, gammax, hOx, thetax, mx, Ax});
            end
        end
        myEq=strcat(myEq, 'prTDFF(x,', Egx, ',', gammax, ',', hOx, ',',...
            thetax, ',', mx, ',', Ax, ') +'); 
    end
    %remove trailing ' +'
    myEq=myEq(1:end-2); 
end

