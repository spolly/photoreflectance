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
%  This function file was written in MATLAB R2013 and modified in MATLAB 2014a,
%  and is part of the project: photoreflectance.
% 
%  Copyright 2014 Stephen J. Polly, RIT; Andrew B. Sindermann, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.

    p = inputParser;
    addOptional(p,'couplePhase','false');
    addOptional(p,'fixM','true');
    addOptional(p,'coupleFKO','false');
    parse(p,varargin{:});

    n=length(initial);

    % Ranges for prFDFF parameters
    erangeF=0.15;        %Value erange determines percentage change allowed    
    EnFplus=1+erangeF;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnFminus=1-erangeF;    %or lower than the input guess.
    EnFmax=max(x)*0.999;
    EnFmin=min(x)*1.001;

    gammaFstart=0.005;
    gammaFup=1;
    gammaFlow=0.0001;

    thetaFstart=0;
    thetaFup=2*pi;
    thetaFlow=-2*pi;

    AFstart=0.001;
    AFup=1e-2;
    AFlow=1e-6;
    % End of ranges for prFDFF parameters
    
    % Ranges for prTDFF parameters
    erangeT=0.03;        %Value erange determines percentage change allowed    
    EnTplus=1+erangeT;     %via bounds for energy. E.g. 0.15 means 15% higher   
    EnTminus=1-erangeT;    %or lower than the input guess.
    EnTmax=max(x)*0.999;
    EnTmin=min(x)*1.001;

    gammaTstart=1e-1;   %Broading factor
    gammaTup=1e0;
    gammaTlow=1e-3;

    thetaTstart=6*pi;       %Phase factor
    thetaTup=6*pi;
    thetaTlow=1*pi;

    mTstart=2.5;         %Exponent factor.
    mTup=4;              %m=2.5: 3D critical point
    mTlow=2;             %m=3: 2D critical point

    ATstart=1e-8;       %Amplitude factor
    ATup=1e-2;
    ATlow=1e-8;
    % End of ranges for prTDFF parameters
    
    % Ranges for prAiryFKO parameters
    erangeFKO=0.01;      %Value erange determines percentage change allowed
    EnFKOplus=1+erangeFKO; %via bounds for energy. E.g. 0.15 means 15% higher
    EnFKOminus=1-erangeFKO;%or lower than the input guess.
    EnFKOmax=max(x)*0.999;
    EnFKOmin=min(x)*1.001;
    
    gammaFKOstart=1e-2;    %Broading factor
    gammaFKOup=1e-1;
    gammaFKOlow=1e-3;
    
    hOFKOstart=1e-2;    %Electro-optical energy
    hOFKOup=1e-0;
    hOFKOlow=1e-3;
    
    phistart=2*pi;     %Phase factor
    phiup=3*pi;
    philow=1*pi;
    
    AFKOstart=1e-1;    %Amplitude factor
    AFKOup=3e0;
    AFKOlow=1e-2;
    % End of ranges for prAiryFKO parameters
    
    
    
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
            
            % Setup ranges for prAiryFKO parameters
            case 'EnFKO'
                %First check to make sure the generatated bounds on the 
                %guesses of energy are inside the data, if not set to just 
                %inside the data range.
                if initial(initialIndex)*EnFKOplus > EnFKOmax
                    EnFKOup=EnFKOmax;
                else
                    EnFKOup=initial(initialIndex)*EnFKOplus;
                end
                if initial(initialIndex)*EnFKOminus < EnFKOmin
                    EnFKOlow=EnFKOmin;
                else
                    EnFKOlow=initial(initialIndex)*EnFKOminus;
                end
                start(i)=initial(initialIndex);
                upper(i)=EnFKOup;
                lower(i)=EnFKOlow;
            case 'gammaFKO'
                start(i)=gammaFKOstart;
                upper(i)=gammaFKOup;
                lower(i)=gammaFKOlow;
            case 'hOFKO'
                start(i)=hOFKOstart;
                upper(i)=hOFKOup;
                lower(i)=hOFKOlow;
            case 'phi'
                start(i)=phistart;
                upper(i)=phiup;
                lower(i)=philow;
            case 'AFKO'
                %For coupled FKO's, the heavy hole response should be
                %dominant, while the light hole response is weaker and with
                %opposite sign.
                if strcmp(p.Results.coupleFKO, 'true')
                    if AFKOup*(-1)^(1+initialIndex) > AFKOlow*(-1)^(1+initialIndex)
                        start(i)=AFKOstart*(-1)^(1+initialIndex);
                        upper(i)=AFKOup*(-1)^(1+initialIndex);
                        lower(i)=AFKOlow*(-1)^(1+initialIndex);
                    else
                        start(i)=0.1*AFKOstart*(-1)^(1+initialIndex);
                        upper(i)=0.1*AFKOlow*(-1)^(1+initialIndex);
                        lower(i)=0.1*AFKOup*(-1)^(1+initialIndex);
                    end
                else
                    start(i)=AFKOstart;
                    upper(i)=AFKOup;
                    lower(i)=AFKOlow;
                end
            initialIndex = initialIndex + 1;
                
            % End setup ranges for prAiryFKO parameters
        end
    end
end          

