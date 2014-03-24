function [myFit,myGof,varargout]=prMultiFit(x,y,initial,type,varargin)
% prMultiFit returns a fit and a gof against the input x and y data, using 
% the sum of n oscillators defined by either prFDFF or prTDFF depending on 
% the contentes of the 'type' vector.
%   Inputs:
%       x: x-values of experimental data (energy) [eV] {vector expected}
%       y: y-values of experimental data (deltaR/R) [unitless] 
%           {vector expected}
%       initial: Estimates of oscillator energy [eV]
%                   {scalar or vector expected}
%       type: Declaration of functional form to use for each item in 
%               'initial'
%   Optional Inputs:
%       'couplePhase': 'false': (default) allows independent phase term  
%                               fits for each oscillator. 
%                      'true': locks all phase terms as one parameter 
%                               within each functional form. e.g.: all 
%                               prFDFF oscillators will share one phase 
%                               term, and all prTFDD oscillators will share 
%                               one phase term.
%   Outputs:
%       myFit: MATLAB fit output [various] {cfit}
%       myGof: MATLAB goodness of fit output [various] {struct}
%
%   Example:
%       initial = [1.1, 1.3, 1.42]; %Three oscillators, at these energies
%       type = [1, 1, 3]; %The first two will use prFDFF, the third, prTDFF
%       [testFit,testGof]=prMultiFit(x,y,initial,type)      
%
%  This was written in MATLAB R2013a, and requires the free/open-source 
%  C++ version of erfi(): Faddeeva_erfi(), written by S. G. Johnson, which 
%  can be found, along with instructions on compiling, at:
%  http://ab-initio.mit.edu/Faddeeva
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
    myEq='';
    myCoeff={};
    F_iter=1;
    T_iter=1;
    if not(length(initial)==length(type))
        err = MException('typeN:OutOfRange', ...
           'Vectors ''initial'' and ''type'' must be the same length.');
        throw(err)
    end
    
    for i=1:n
        switch type(i)
            case 1 %Use prFDFF
                [tempEq, tempCoeff] = prFDFFn(1, 'iteration', F_iter,...
                    'couplePhase', p.Results.couplePhase);
                myEq = strcat(myEq, tempEq, ' + ');
                myCoeff = horzcat(myCoeff, tempCoeff);
                F_iter = F_iter + 1;
            case 3 %Use prTDFF
                [tempEq, tempCoeff] = prTDFFn(1, 'iteration', T_iter,...
                    'couplePhase', p.Results.couplePhase, 'fixM',...
                    p.Results.fixM);
                myEq = strcat(myEq, tempEq, ' + ');
                myCoeff = horzcat(myCoeff, tempCoeff);
                T_iter = T_iter + 1;
            case 'fko' %Use prFKO
            otherwise
                err = MException('type:OutOfRange', ...
                    'Type value is outside expected range (1, 3,''fko'')');
                throw(err)
        end
        if i==n
            myEq=myEq(1:end-2);
        end
    end
    
    myFitType=fittype(myEq, 'dependent',{'y'},'independent',{'x'},...
    'coefficients', myCoeff);

    [start,upper,lower]=prMultiFitSetup(x,initial, myCoeff, 'couplePhase',...
        p.Results.couplePhase);

    [myFit,myGof]=fit(x,y,myFitType,'StartPoint', start, 'Upper', upper,...
        'Lower', lower, 'MaxFunEvals', 5000, 'MaxIter', 5000,...
        'TolFun', 1e-10, 'TolX', 1e-10, 'DiffMinChange', 1e-12);
    
    myPlot=plot(myFit,'k',x,y);
        set(myPlot,'LineWidth', 3);
        
        
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
        T_iter=1;
         for j=1:n
             switch type(j)
                 case 1
                     %y=prFDFF(E,En,gamma,theta,A)
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
                     

                     myFDFF(:,F_iter)=prFDFF(x, myEnF, myGammaF,...
                         myThetaF, myAF);
                     F_iter = F_iter + 1;

                 case 3
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
                 case 'fko'
                 otherwise
                    err = MException('type:OutOfRange', ...
                        ['Type value is outside expected range'...
                         '(1, 3, ''fko'')']);
                    throw(err)
             end
         end
         hold on
         if exist('myFDFF', 'var')
            plot(x,myFDFF, 'linewidth', 1);
         end
         if exist('myTDFF', 'var')
            plot(x,myTDFF, 'linewidth', 1);
         end
         hold off
    end
end

