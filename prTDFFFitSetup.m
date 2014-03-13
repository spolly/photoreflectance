function [start, upper, lower]=prTDFFFitSetup(x,initial,varargin)
% prTDFFFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
%       n: Number of oscillators to use [unitless] {scalar expected}
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%       'fixM': 'true': (default) locks the exponent 'm' as 2.5, typical 
%                       for a three dimentional critical point.
%               'false': allows independent 'm' term for each oscillator.
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

    gammastart=0.005;   %Broading factor
    gammaup=0.1;
    gammalow=0.0001;

    hOstart=0.01;       %Electro-optical factor
    hOup=1;             %dependents include E-field 
    hOlow=0.00001;      %and interband effective mass

    thetastart=0;       %Phase factor
    thetaup=pi;
    thetalow=-pi;

    mstart=2.5;         %Exponent factor.
    mup=4;              %m=2.5: 3D critical point
    mlow=2;             %m=3: 2D critical point

    Astart=0.001;       %Amplitude factor
    Aup=1e-2;
    Alow=1e-6;

    start=[];
    upper=[];
    lower=[];
    %       f=prTDFF(x,Eg,gamma,hO,theta,m,A)
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
        %only appears in the first set of concatenations. If m is fixed, it  
        %is simply set to 2.5 and not included as a parameter at all.
        if strcmp(p.Results.fixM, 'true')
            if strcmp(p.Results.couplePhase, 'true') && i > 1
                start=horzcat(start, initial(i), gammastart, hOstart,...
                    Astart);
                upper=horzcat(upper, Eup, gammaup, hOup, Aup);
                lower=horzcat(lower, Elow, gammalow, hOlow, Alow);
            else
                start=horzcat(start, initial(i), gammastart, hOstart,...
                    thetastart, Astart);
                upper=horzcat(upper, Eup, gammaup, hOup, thetaup,...
                     Aup);
                lower=horzcat(lower, Elow, gammalow, hOlow,...
                    thetalow, Alow);
            end
        else
            if strcmp(p.Results.couplePhase, 'true') && i > 1
                start=horzcat(start, initial(i), gammastart, hOstart,...
                    mstart, Astart);
                upper=horzcat(upper, Eup, gammaup, hOup, mup, Aup);
                lower=horzcat(lower, Elow, gammalow, hOlow, mlow,...
                    Alow);
            else
                start=horzcat(start, initial(i), gammastart, hOstart,...
                    thetastart, mstart, Astart);
                upper=horzcat(upper, Eup, gammaup, hOup, thetaup,...
                    mup, Aup);
                lower=horzcat(lower, Elow, gammalow, hOlow, thetalow,...
                    mlow, Alow);
            end
        end
    end
end