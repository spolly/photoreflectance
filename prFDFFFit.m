function [myFit,myGof]=prFDFFFit(x,y,initial,varargin)
% prFDFFFit returns a fit and a gof against the input x and y data, using 
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
%   Outputs:
%       myFit: MATLAB fit [various] {cfit}
%       myGof: MATLAB goodness of fit [various] {struct}
%
%  This function file was written in MATLAB R2013a, and is part of the
%  project: photoreflectance. It requires the free/open-source 
%  C++ version of erfi(): Faddeeva_erfi(), written by S. G. Johnson, which 
%  can be found, along with instructions on compiling, at:
%  http://ab-initio.mit.edu/Faddeeva
% 
%  Copyright 2014 Stephen J. Polly, RIT
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License v3. 

    p = inputParser;
    addOptional(p,'couplePhase','false');
    addOptional(p,'plotFitOnly','false');
    addOptional(p,'plotAll','true');
    parse(p,varargin{:});
    
    n=length(initial);
    
    [myEq, myCoeff]=prFDFFn(n, 'couplePhase', p.Results.couplePhase);
    
    myFitType=fittype(myEq, 'dependent',{'y'},'independent',{'x'},...
    'coefficients', myCoeff);

    [start,upper,lower]=prFDFFFitSetup(x,initial, myCoeff,...
        'couplePhase', p.Results.couplePhase);

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
        F_iter=1;
        myFDFF=zeros(length(x), n);
        for j=1:n
             myName=strcat('EnF',num2str(F_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myEnF=fitCoeff(boolIndex);

             myName=strcat('gammaF',num2str(F_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myGammaF=fitCoeff(boolIndex);

             if strcmp(p.Results.couplePhase, 'true')
                 myName='thetaF00';
             else
                 myName=strcat('thetaF',num2str(F_iter,'%02d'));
             end
             boolIndex = strcmp(myName, fitCoeffNames);
             myThetaF=fitCoeff(boolIndex);

             myName=strcat('AF',num2str(F_iter,'%02d'));
             boolIndex = strcmp(myName, fitCoeffNames);
             myAF=fitCoeff(boolIndex);

             myFDFF(:,F_iter)=prFDFF(x, myEnF, myGammaF, myThetaF, myAF);
             F_iter = F_iter + 1;
         end
         hold on
         plot(x,myFDFF, 'linewidth', 1);
         hold off
    end
end
