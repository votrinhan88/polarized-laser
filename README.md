# polarized-laser
This repo contains an MATLAB scripts to extract features of polarized light.  
This is part of my *Pre-thesis* study *'Polarization characteristics of IgG and IgM in interaction with gold nanoparticles for COVID-19 detection'* (HCMIU VNU-HCMC, Sep 2020 - Jan 2021).  

What each script does:
- main.m (main script):
    - Input data (.csv), calculate and debug the parameters, save data (.xls)
- statAnalyze.m:
    - A function calculating mean, standard deviation, and (max - min) of each parameters to check for stability
- examineAngle.m:
    - A function to check for error state of the angles after performing inverse trigonometric functions (due to mismatched output domains).
    - If mismatched, outputs will be passed to quarterShiftPositive
- quarterShiftPositive.m:
    - Shift angles from negative to positive domains (eg. from [-90°, 0°) to [90°, 180°))
- plotParameters.m:
    - Visualize 12 effective parameters
- DOPLinear.m:
    - Visualize the remaining parameter Degree of Polarization