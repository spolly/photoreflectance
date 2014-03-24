photoreflectance
================

Functions for extracting parameters from photoreflectance data.

These files were created in MATLAB R2013a.

Copyright 2014 Stephen J. Polly, RIT  
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License v3.

Dependencies
--------------
Parts of this project require the free/open-source  C++ version of the imaginary error function
`Faddeeva_erfi()`, written by S. G. Johnson, which can be found, along with instructions on compiling in MATLAB, at:  
http://ab-initio.mit.edu/Faddeeva

Function Files
--------------
###First Derivative Functional Form (FDFF)
* `prFDFF.m` Calculates FDFF photoreflectance spectra for a given set of inputs.
* `prFDFFFit.m` Performs a fit of (n) FDFF oscillators against input data.
* `prFDFFFitSetup.m` Sets starting conditions, as well as upper and lower bounds for the fit performed by `prFDFFFit.m`.
* `prFDFFn.m` Defines a fittype string and vector of coefficients necessary to fit (n) oscillators with.  

###Third Derivative Functional Form (TDFF)
* `prTDFF.m` Calculates photoreflectance spectra for a given set of inputs.
* `prTDFFFit.m` Performs a fit of (n) oscillators against input data.
* `prTDFFFitSetup.m` Sets starting conditions, as well as upper and lower bounds for the fit performed by `prTDFFFit.m`.
* `prTDFFn.m` Defines a fittype string and vector of coefficients necessary to fit (n) oscillators with.
* `prCHF.m` Calculates the confluent hypergeometric function, psi(1, 1/2, -x^2/2), necessary for the FDFF. This function file requires `Faddeeva_erfi()` as listed in the dependencies section above.

###MultiFit - Arbitrary mix of FDFF and TDFF
* `prMultiFit.m` Performs a fit of (n) FDFF and/or TDFF oscillators against input data.
* `prMultiFitSetup.m` Sets starting conditions, as well as upper and lower bounds for the fit performed by `prTDFFFit.m`.

How to use these scripts
------------------------

###To produce an example photoreflectance deltaR/R plot
####Third derivative functional form (TDFF)
Files needed:
* `prTDFF.m`  

For, e.g. GaAs:  
First create a vector of energies to plot over, here 1.3 to 1.5 eV in steps of 1 meV:

```matlab
E= 1.3 : 0.001 : 1.5;
```

Then calculate the corresponding PR signal with a call to `prTDFF.m`. In this example:
* Eg = 1.42 eV
* gamma = 0.01 eV
* hO = 0.001 eV
* theta = 0
* m = 2.5
* A = 1e-4

```matlab
PR = prTDFF(E, 1.42, 0.01, 0.001, 0, 2.5, 1e-4);
```

Which is then plotted:

```matlab
plot(E, PR);
```

Please see the comments at the top of `prTDFF.m` for more information.

#### First Derivative Functional Form (FDFF)
Files needed:
* `prFDFF.m` 
* `prCHF.m` (Also requires `Faddeeva_erfi()` as listed in the dependencies section above)

For, e.g. a bound quantum well state:  
First create a vector of energies to plot over, here 1.1 to 1.4 eV in steps of 1 meV:

```matlab
E = 1.1 : 0.001 : 1.4;
```

Then calculate the corresponding PR signal with a call to `prFDFF.m`. In this example:
* Eg = 1.21 eV
* gamma = 0.01 eV
* theta = 0
* A = 1e-4

```matlab
PR = prFDFF(E, 1.21, 0.01, 1e-4);
```

Which is then plotted:

```matlab
plot(E, PR);
```

Please see the comments at the top of `prFDFF.m` for more information.

###To fit data against (n) oscillators:
####Using TDFF
Files needed:
* `prFDFF.m`
* `prFDFFFit.m`
* `prFDFFFitSetup.m`
* `prFDFFn.m`

Import experimental data to MATLAB. In this example, x-data is 'E' and y-data is 'PR'.
Make a vector of educated guesses of where the oscillators lie:

```matlab
initial = [1.42];
```

Make a call to `prTDFFFit.m` using the experimental data and the 'initial' vector. Here we set testFit and testGOF to the fit output and goodness of fit output, respectively. Since the vector 'initial' has 1 value, a 1-oscillator fit will be created and used.

```matlab
[testFit, testGOF] = prTDFFFit(E, PR, initial);
```

This function accepts additional inputs (default is listed first):
* 'fixM': 'true' or 'false'. This fixes the m-exponent to 2.5 (true) or sets it as a floating fitting parameter (false).
* 'couplePhase': 'false' or 'true'. This allows each oscillator to have a separate phase term, or couples all oscillators to one phase parameter.
* 'plotFitOnly': 'false' or 'true'. Plots the resulting fit against the data (true) or checks against 'plotAll'.
* 'plotAll': 'true' or 'false': Plots the fit as well as the component functions (true) or does not plot anything (false).

The fitting process flow is as follows:
`prTDFFFit.m` calls `prTDFFn.m` which returns the equation to fit against, as well as all coefficients in a vector. 
It then creates a fittype, followed by a call to `prTDFFFitSetup.m` where the starting point, and upper and lower bounds
are set. If the fit() is resulting in poor fits or is hitting boundaries, they should be changed within the setup file.
The fit() is then performed. Here the tolerance and number of iterations can be changed. Finally any plotting is
performed.

####Using FDFF
Files needed:
* `prTDFF.m`
* `prTDFFFit.m`
* `prTDFFFitSetup.m`
* `prTDFFn.m`
* `prCHF.m` (Also requires `Faddeeva_erfi()` as listed in the dependencies section above)

Import experimental data to MATLAB. In this example, x-data is 'E' and y-data is 'PR'.
Make a vector of educated guesses of where the oscillators lie:

```matlab
initial = [1.1, 1.16, 1.23, 1.37];
```

Make a call to `prFDFFFit.m` using the experimental data and the 'initial' vector. Here we set testFit and testGOF to the fit output and goodness of fit output, respectively. Since the vector 'initial' has 4 values, a 4-oscillator fit will be created and used.

```matlab
[testFit, testGOF] = prFDFFFit(E, PR, initial);
```

This function accepts additional inputs (default is listed first):
* 'couplePhase': 'false' or 'true'. This allows each oscillator to have a separate phase term, or couples all oscillators to one phase parameter.
* 'plotFitOnly': 'false' or 'true'. Plots the resulting fit against the data (true) or checks against 'plotAll'.
* 'plotAll': 'true' or 'false': Plots the fit as well as the component functions (true) or does not plot anything (false).

The fitting process flow is as follows:
`prFDFFFit.m` calls `prFDFFn.m` which returns the equation to fit against, as well as all coefficients in a vector. 
It then creates a fittype, followed by a call to `prFDFFFitSetup.m` where the starting point, and upper and lower bounds
are set. If the fit() is resulting in poor fits or is hitting boundaries, they should be changed within the setup file.
The fit() is then performed. Here the tolerance and number of iterations can be changed. Finally any plotting is
performed.
####Using MultiFit
Files needed:
* `prTDFF.m`
* `prMultiFit.m`
* `prMultiFitSetup.m`
* `prFDFFn.m`
* `prTDFFn.m`
* `prCHF.m` (Also requires `Faddeeva_erfi()` as listed in the dependencies section above)

This method fits an arbitrary, user defined mix of FDFF and TDFF oscillators.  

Import experimental data to MATLAB. In this example, x-data is 'E' and y-data is 'PR'.
Make a vector of educated guesses of where the oscillators lie:

```matlab
initial = [[1.1, 1.16, 1.23, 1.37, 1.42];
```

Next, define an oscillator type for each of those energies:

```matlab
type = [1, 1, 1, 1, 3];
```

In this example, the first 4 oscillators will use the FDFF by setting the 'type(1:4)' to 1, while the fifth oscillator will use the TDFF by setting 'type(5)' to 3.

Make a call to `prMultiFit.m` using the experimental data and the 'initial' vector. Here we set testFit and testGOF to the fit output and goodness of fit output, respectively. Since the vector 'initial' has 2 values, a 2-oscillator fit will be created and used.

```matlab
[testFit, testGOF] = prMultiFit(E, PR, initial, type);
```

This function accepts additional inputs (default is listed first):
* 'fixM': 'true' or 'false'. This fixes the m-exponent to 2.5 (true) or sets it as a floating fitting parameter (false).
* 'couplePhase': 'false' or 'true'. This allows each oscillator to have a separate phase term, or couples all oscillators to one phase parameter.
* 'plotFitOnly': 'false' or 'true'. Plots the resulting fit against the data (true) or checks against 'plotAll'.
* 'plotAll': 'true' or 'false': Plots the fit as well as the component functions (true) or does not plot anything (false).

The fitting process flow is as follows:
`prMultiFit.m` calls `prTDFFn.m` and/or `prFDFFn.m` which returns the equation to fit against, as well as all coefficients in a vector.
It then creates a fittype, followed by a call to `prMultiFitSetup.m` where the starting point, and upper and lower bounds
are set. If the fit() is resulting in poor fits or is hitting boundaries, they should be changed within the setup file.
The fit() is then performed. Here the tolerance and number of iterations can be changed. Finally any plotting is
performed.

