function [start, upper, lower]=prFDFFFitSetup(x,initial,varargin)
% prFDFFFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
%       n: Number of oscillators to use [unitless] {scalar expected}
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%   Outputs:
%       start: Starting point of all parameters [various] {vector}
%       upper: Upper bounds of all parameters [various] {vector}
%       lower: Lower bounds of all parameters [various] {vector}
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'couplePhase','false');
    addOptional(p,'fixM','true');
    parse(p,varargin{:});

    n=length(initial);


    erange=0.15;        %Value erange determines percentage change allowed    
    Eplus=1+erange;     %via bounds for energy. E.g. 0.15 means 15% higher   
    Eminus=1-erange;    %or lower than the input guess.
    Emax=max(x)*0.999;
    Emin=min(x)*1.001;

    gammastart=0.01;
    gammaup=1;
    gammalow=0.0001;

    thetastart=0;
    thetaup=2*pi;
    thetalow=-2*pi;

    Cstart=0.001;
    Cup=.01;
    Clow=.0000001;

    start=[];
    upper=[];
    lower=[];

    for i=1:n
        %First check to make sure the generatated bounds on the guesses of
        %energy are inside the data, if not set to just inside the data
        %range.
        if initial(i)*Eplus > Emax
            Eup=Emax;
        else
            Eup=initial(i)*Eplus;
        end
        if initial(i)*Eminus < Emin
            Elow=Emin;
        else
            Elow=initial(i)*Eminus;
        end
        %The bounding vectors are built differently depending on what 
        %(from phase and m terms) are fixed. If phase is fixed, theta1 is 
        %the only phase parameter, which is used in each function call, but 
        %only appears in the first set of concatenations. 
        if strcmp(p.Results.couplePhase, 'true') && i > 1
            start=horzcat(start, initial(i), gammastart, Cstart);
            upper=horzcat(upper, Eup, gammaup, Cup);
            lower=horzcat(lower, Elow, gammalow, Clow);
        else
            start=horzcat(start, initial(i), gammastart, thetastart,...
                Cstart);
            upper=horzcat(upper, Eup, gammaup, thetaup, Cup);
            lower=horzcat(lower, Elow, gammalow, thetalow, Clow);
        end
    end
end