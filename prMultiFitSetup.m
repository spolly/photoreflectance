function [start, upper, lower] = prMultiFitSetup(x,initial,myCoeff,...
                                    varargin)
% prMultiFitSetup returns vectors describing initial conditions, as well as 
% upper and lower bounds for the fitting function.
%   Inputs:
%       x: x-values of experimental data [eV] {vector expected}
% initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
% myCoeff: Names of coefficients used in the equation, as output by
%                   prTDFFn.m and/or prFDFFn.m.
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

    % Ranges for prFDFF parameters
    erangeF=0.10;        %Value erange determines percentage change allowed    
    EnFplus=1+erangeF;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnFminus=1-erangeF;    %or lower than the input guess.
    EnFmax=max(x)*0.999;
    EnFmin=min(x)*1.001;

    gammaFstart=0.05;
    gammaFup=1;
    gammaFlow=0.0001;

    thetaFstart=0;
    thetaFup=2*pi;
    thetaFlow=-2*pi;

    AFstart=0.001;
    AFup=.01;
    AFlow=.0000001;
    % End of ranges for prFDFF parameters
    
    % Ranges for prTDFF parameters
    erangeT=0.2;        %Value erange determines percentage change allowed    
    EnTplus=1+erangeT;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnTminus=1-erangeT;    %or lower than the input guess.
    EnTmax=max(x)*0.999;
    EnTmin=min(x)*1.001;

    gammaTstart=0.05;   %Broading factor
    gammaTup=1;
    gammaTlow=0.0001;

    hOTstart=0.01;       %Electro-optical factor
    hOTup=1;             %dependents include E-field 
    hOTlow=0.00001;      %and interband effective mass

    thetaTstart=0;       %Phase factor
    thetaTup=pi;
    thetaTlow=-pi;

    mTstart=2.5;         %Exponent factor.
    mTup=4;              %m=2.5: 3D critical point
    mTlow=2;             %m=3: 2D critical point

    ATstart=0.001;       %Amplitude factor
    ATup=1e-2;
    ATlow=1e-7;
    % End of ranges for prTDFF parameters
    
    
    cLength=length(myCoeff);
    start(cLength)=zeros;
    upper(cLength)=zeros;
    lower(cLength)=zeros;
    initialIndex = 1;
    for i=1:cLength
        switchparam = char(myCoeff(i));
        %nparam=str2num(switchparam(end-1:end));
        switch switchparam(1:end-2)
            % Setup ranges for prFDFF parameters
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
            % End setup ranges for prFDFF parameters

            % Setup ranges for prTDFF parameters
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
            case 'hOT'
                start(i)=hOTstart;
                upper(i)=hOTup;
                lower(i)=hOTlow;
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
            % End setup ranges for prTDFF parameters
        end
    end
end

