photoreflectance
================

Functions for extracting parameters from photoreflectance data.

These files were created in MATLAB R2013a.

Copyright 2014 Stephen J. Polly, RIT
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License v3.

Function Files
--------------

* `prTDFF.m` Calculates photoreflectance spectra for a given set of inputs.
* `prTDFFFit.m` Performs a fit of (n) oscillators against input data.
* `prTDFFFitSetup.m' Sets starting conditions, as well as upper and lower bounds for the fit performed by prTDFFFit.m.
* `prTDFFn.m` Defines a fittype string and vector of coefficients necessairy to fit (n) oscillators with.

How to use these scripts
------------------------

To produce an example photoreflectance deltaR/R plot for, e.g. GaAs:
First create a vector of energies to plot over, here 1.3 to 1.5 eV in steps of 1 meV:
>> E=1.3:0.001:1.5;<<
Then calculate the corrisponding PR signal with a call to `prTDFF.m`. In this example:
Eg = 1.42 eV
gamma = 0.01 eV,
hO = 0.001 eV
theta = 0
m = 2.5
A = 1e-4
>> PR=prTDFF(E,1.42,0.01,0.001,0,2.5,1e-4)
>> plot(E, prTDFF(E,1.42,0.01,0.001,0,2.5,1e-4));
Please see the comments at the top of `prTDFF.m` for more information.

To fit data against (n) oscillators:
Import experimental data to MATLAB. In this example, x-data is 'E' and y-data is 'PR'.
Make a vector of educated guesses of where the oscillators lie:
>> initial=[1.42, 1.5]
Make a call to `prTDFFFit.m` using the experimental data and the guess vector. Here we set testFit and testGOF to the
fit output and goodness of fit output, respectively:
>> [testFit, testGOF]= prTDFFFit(E,PR,initial);
This function accepts additional inputs (default is listed first):
'fixM': 'true' or 'false'. This fixes the m-exponent to 2.5 (true) or sets it as a floating fitting parameter (false).
'couplePhase', 'false', 'true'. This allows each oscillator to have a separate phase term, or couples all oscillators to 
one phase paramter.
'plotFitOnly': 'false' or 'true'. Plots the resulting fit against the data (true) or checks against 'plotAll'.
'plotAll': 'true' or 'false': Plots the fit as well as the component functions (true) or does not plot anything (false).

The fitting process flow is as follows:
`prTDFFFit.m` calls `prTDFFn.m` which returns the equation to fit against, as well as all coefficients in a vector. 
It then creates a fittype, followed by a call to `prTDFFFitSetup.m` where the starting point, and upper and lower bounds
are set. If the fit() is resulting in poor fits or is hitting boundaries, they should be changed within the setup file.
The fit() is then performed. Here the tolerance and number of iterations can be changed. Finally any plotting is
performed.

