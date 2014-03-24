function [myFit,myGof]=prTDFFFit(x,y,initial,varargin)
% prTDFFFit returns a fit and a gof against the input x and y data, using 
% the sum of n oscillators defined by prTDFF.
%   Inputs:
%       x: x-values of experimental data (energy) [eV] {vector expected}
%       y: y-values of experimental data (deltaR/R) [unitless] 
%           {vector expected}
%       initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each  oscillator. 
%                      'true': locks all phase terms as one parameter.
%       'fixM': 'true': (default) locks the exponent 'm' as 2.5, typical 
%                       for a three dimentional critical point.
%               'false': allows independent 'm' term for each oscillator.
%   Outputs:
%       myFit: MATLAB fit output [various] {cfit}
%       myGof: MATLAB goodness of fit output [various] {struct}
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3.    
    p = inputParser;
    addOptional(p,'couplePhase','false');
    addOptional(p,'fixM','true');
    addOptional(p,'plotFitOnly','false');
    addOptional(p,'plotAll','true');
    parse(p,varargin{:});
    
    n=length(initial);
    
    [myEq, myCoeff]=prTDFFn(n, 'couplePhase', p.Results.couplePhase,...
        'fixM', p.Results.fixM);
    
    myFitType=fittype(myEq, 'dependent',{'y'},'independent',{'x'},...
    'coefficients', myCoeff);

    [start,upper,lower]=prTDFFFitSetup(x,initial, myCoeff,...
        'couplePhase', p.Results.couplePhase, 'fixM', p.Results.fixM);

    [myFit,myGof]=fit(x,y,myFitType,'StartPoint', start, 'Upper', upper,...
        'Lower', lower, 'MaxFunEvals', 5000, 'MaxIter', 5000,...
        'TolFun', 1e-10, 'TolX', 1e-10, 'DiffMinChange', 1e-12);
    
    %Build plots based on variable inputs
    if strcmp(p.Results.plotFitOnly, 'true')
        myPlot=plot(myFit,'k',x,y);
        set(myPlot,'LineWidth', 3);
    elseif strcmp(p.Results.plotAll, 'true')
        myPlot=plot(myFit,'k',x,y);
        set(myPlot,'LineWidth', 3);
        fitCoeff=coeffvalues(myFit);
        fitCoeffNames=coeffnames(myFit);
        T_iter=1;
         for j=1:n
             %f=prTDFF(x,Eg,gamma,hO,theta,m,A)
             myName=strcat('EnT',num2str(T_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myEnT=fitCoeff(boolIndex);

             myName=strcat('gammaT',num2str(T_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myGammaT=fitCoeff(boolIndex);

             myName=strcat('hOT',num2str(T_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myHOT=fitCoeff(boolIndex);

             if strcmp(p.Results.couplePhase, 'true')
                 myName='thetaT00';
             else
                 myName=strcat('thetaT',num2str(T_iter,'%02d'));
             end
             boolIndex = strcmp(myName, fitCoeffNames);
             myThetaT=fitCoeff(boolIndex);

             if strcmp(p.Results.fixM, 'true')
                myMT=2.5;
             else
                myName=strcat('mT',num2str(T_iter,'%02d'));
                boolIndex = strcmp(myName, fitCoeffNames);
                myMT=fitCoeff(boolIndex);
             end

             myName=strcat('AT',num2str(T_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myAT=fitCoeff(boolIndex);

             myTDFF(:,T_iter)=prTDFF(x, myEnT, myGammaT,...
                 myHOT, myThetaT, myMT, myAT);
             T_iter = T_iter + 1;
         end
         hold on
         plot(x,myTDFF, 'linewidth', 1);
         hold off
    end
end

