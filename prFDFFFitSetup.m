function [start, upper, lower]=prFDFFFitSetup(x,initial,myCoeff,varargin)
% prFDFFFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
%       initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
%       myCoeff: Names of coefficients used in the equation, as output by
%                   prFDFFn.m
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%   Outputs:
%       start: Starting point of all parameters [various] {vector}
%       upper: Upper bounds of all parameters [various] {vector}
%       lower: Lower bounds of all parameters [various] {vector}
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
    parse(p,varargin{:});

    erange=0.15;        %Value erange determines percentage change allowed    
    EnFplus=1+erange;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnFminus=1-erange;    %or lower than the input guess.
    EnFmax=max(x)*0.999;
    EnFmin=min(x)*1.001;

    gammaFstart=5e-3;
    gammaFup=5e-1;
    gammaFlow=1e-4;

    thetaFstart=0;
    thetaFup=2*pi;
    thetaFlow=-2*pi;

    AFstart=1e-3;
    AFup=1e-2;
    AFlow=1e-7;

    cLength=length(myCoeff);
    start(cLength)=zeros;
    upper(cLength)=zeros;
    lower(cLength)=zeros;
    
    initialIndex = 1;

    for i=1:cLength
        switchparam = char(myCoeff(i));
        switch switchparam(1:end-2)
            case 'EnF'
                %First check to make sure the generatated bounds on the 
                %guesses of energy are inside the data, if not set to just 
                %inside the data range.
                if initial(initialIndex)*EnFplus > EnFmax
                    EnFup=EnFmax;
                else
                    EnFup=initial(initialIndex)*EnFplus;
                end
                if initial(initialIndex)*EnFminus < EnFmin
                    EnFlow=EnFmin;
                else
                    EnFlow=initial(initialIndex)*EnFminus;
                end
                start(i)=initial(initialIndex);
                upper(i)=EnFup;
                lower(i)=EnFlow;
                initialIndex = initialIndex + 1;
            case 'gammaF'
                start(i)=gammaFstart;
                upper(i)=gammaFup;
                lower(i)=gammaFlow;
            case 'thetaF'
                start(i)=thetaFstart;
                upper(i)=thetaFup;
                lower(i)=thetaFlow;
            case 'AF'
                start(i)=AFstart;
                upper(i)=AFup;
                lower(i)=AFlow;
        end
    end
end