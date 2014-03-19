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
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'couplePhase','false');
    parse(p,varargin{:});
    
    myEq='';
    myCoeff={};
    for i=1:n
        nx=num2str(i);
        Enx=strcat('En',nx);
        gammax=strcat('gamma',nx);
        Cx=strcat('C',nx);
        %The Coefficient vector is built differently depending on if the 
        %phase term is fixed or not. If phase is fixed, theta1 is the only 
        %phase parameter, which is used in each function call. Otherwise
        %they are enumerated as the rest of the parameters.
        if strcmp(p.Results.couplePhase, 'true') && i > 1
            thetax=strcat('theta','1');
            myCoeff=horzcat(myCoeff, {Enx, gammax, Cx});
        elseif strcmp(p.Results.couplePhase, 'true')
            thetax=strcat('theta','1');
            myCoeff=horzcat(myCoeff, {Enx, gammax, thetax, Cx});
        else
            thetax=strcat('theta',nx);
            myCoeff=horzcat(myCoeff, {Enx, gammax, thetax, Cx});
        end
        myEq=strcat(myEq, 'prFDFF(x, ', Enx, ',', gammax, ',', thetax,...
            ',', Cx, ') +');
    end
    %remove trailing ' +'
    myEq=myEq(1:end-2);
end