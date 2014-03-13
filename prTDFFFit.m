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
%       upper: MATLAB goodness of fit output [various] {struct}
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

    [start,upper,lower]=prTDFFFitSetup(x,initial, 'couplePhase',...
        p.Results.couplePhase, 'fixM', p.Results.fixM);

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
        if strcmp(p.Results.fixM, 'true')
            mj=2.5;
            for j=1:n
                if strcmp(p.Results.couplePhase, 'true')
                   thetaj(j)=fitCoeff(4);
                   if j == 1
                       Egj(j)=fitCoeff(1);
                       gammaj(j)=fitCoeff(2);
                       hOj(j)=fitCoeff(3);
                       Aj(j)=fitCoeff(5);
                   else
                       offset=5+(j-2)*4;
                       Egj(j)=fitCoeff(offset+1);
                       gammaj(j)=fitCoeff(offset+2);
                       hOj(j)=fitCoeff(offset+3);
                       Aj(j)=fitCoeff(offset+4);
                   end
                else
                    offset=(j-1)*5;
                    Egj(j)=fitCoeff(offset+1);
                    gammaj(j)=fitCoeff(offset+2);
                    hOj(j)=fitCoeff(offset+3);
                    thetaj(j)=fitCoeff(offset+4);
                    Aj(j)=fitCoeff(offset+5);
                end
                myTDFF(:,j)=prTDFF(x, Egj(j), gammaj(j), hOj(j),...
                    thetaj(j), mj, Aj(j));
            end
        else
            for j=1:n
                if strcmp(p.Results.couplePhase, 'true')
                    thetaj(j)=fitCoeff(4);
                    if j == 1
                        Egj(j)=fitCoeff(1);
                        gammaj(j)=fitCoeff(2);
                        hOj(j)=fitCoeff(3);
                        mj(j)=fitCoeff(5);
                        Aj(j)=fitCoeff(6);
                    else
                        offset=6+(j-2)*5;
                        Egj(j)=fitCoeff(offset+1);
                        gammaj(j)=fitCoeff(offset+2);
                        hOj(j)=fitCoeff(offset+3);
                        mj(j)=fitCoeff(offset+4);
                        Aj(j)=fitCoeff(offset+5);
                    end
                else
                    offset=(j-1)*6;
                    Egj(j)=fitCoeff(offset+1);
                    gammaj(j)=fitCoeff(offset+2);
                    hOj(j)=fitCoeff(offset+3);
                    thetaj(j)=fitCoeff(offset+4);
                    mj(j)=fitCoeff(offset+5);
                    Aj(j)=fitCoeff(offset+6);
                end
                myTDFF(:,j)=prTDFF(x, Egj(j), gammaj(j), hOj(j),...
                    thetaj(j), mj(j), Aj(j));
            end
        end
        hold on
        plot(x,myTDFF, 'linewidth', 1);
        hold off
    end
end

