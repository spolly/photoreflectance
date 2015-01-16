function [start, upper, lower]=prTDFFFitSetup(x,initial, myCoeff, varargin)
% prTDFFFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
%       initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
%       myCoeff: Names of coefficients used in the equation, as output by
%                   prTDFFn.m
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
    EnTplus=1+erange;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnTminus=1-erange;    %or lower than the input guess.
    EnTmax=max(x)*1.02;
    EnTmin=min(x)*0.98;

    gammaTstart=0.005;   %Broading factor
    gammaTup=1.0;
    gammaTlow=0.0001;

    thetaTstart=0;       %Phase factor
    thetaTup=pi;
    thetaTlow=-pi;

    mTstart=2.5;         %Exponent factor.
    mTup=4;              %m=2.5: 3D critical point
    mTlow=2;             %m=3: 2D critical point

    ATstart=0.001;       %Amplitude factor
    ATup=1e-2;
    ATlow=1e-6;

    cLength=length(myCoeff);
    start(cLength)=zeros;
    upper(cLength)=zeros;
    lower(cLength)=zeros;
    initialIndex = 1;
    for i=1:cLength
        switchparam = char(myCoeff(i));
        %nparam=str2num(switchparam(end-1:end));
        switch switchparam(1:end-2)
            case 'EnT'
                %First check to make sure the generatated bounds on the 
                %guesses of energy are inside the data, if not set to just 
                %inside the data range.
                if initial(initialIndex)*EnTplus > EnTmax
                    EnTup=EnTmax;
                else
                    EnTup=initial(initialIndex)*EnTplus;
                end
                if initial(initialIndex)*EnTminus < EnTmin
                    EnTlow=EnTmin;
                else
                    EnTlow=initial(initialIndex)*EnTminus;
                end
                start(i)=initial(initialIndex);
                upper(i)=EnTup;
                lower(i)=EnTlow;
                initialIndex = initialIndex + 1;
            case 'gammaT'
                start(i)=gammaTstart;
                upper(i)=gammaTup;
                lower(i)=gammaTlow;
            case 'thetaT'
                start(i)=thetaTstart;
                upper(i)=thetaTup;
                lower(i)=thetaTlow;
            case 'mT'
                start(i)=mTstart;
                upper(i)=mTup;
                lower(i)=mTlow;
            case 'AT'
                start(i)=ATstart;
                upper(i)=ATup;
                lower(i)=ATlow;
        end
    end
end