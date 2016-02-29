%% Input file manipulation for the OPT_design

tt=fopen('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\OPT\PROP_DESIGN_OPT_INPUT.txt','w');

%% Enviornemnt
% OPTIMIZE FOR TAKEOFF OR CRUISE; 1 FOR TAKEOFF, 2 FOR CRUISE (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',2);
% AIRCRAFT VELOCITY, PROGRAM SETS THIS TO ZERO IF OPTIMIZING FOR TAKEOFF (MACH NUMBER)
fprintf(tt,'%.5f\r\n',0.361);
% ALTITUDE (FEET)
fprintf(tt,'%.1f\r\n',25e3);

%% Design Conditions
%  SET GEOMETRY BASED ON; 1 SHAFT POWER (SHP), 2 THRUST (N), OR 3 VOLUMETRIC FLOW RATE (CFM)
fprintf(tt,'%g\r\n',2);
% ENTER TARGET VALUE; 1 SHAFT POWER (SHP), 2 THRUST (N), OR 3 VOLUMETRIC FLOW RATE (CFM)
fprintf(tt,'%.1f\r\n',300);
% SHAFT ANGULAR VELOCITY (RPM)
fprintf(tt,'%.1f\r\n',2000);

%% Additional Conditions
% MIN. NUMBER OF BLADES (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',5);
% MX. NUMBER OF BLADES (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',12);
% MAX. ALLOWABLE RADIUS (METERS)
fprintf(tt,'%0.f\r\n',1.5);
% MINIMUM RADIUS/CHORD RATIO (REAL, NON-DIM)
fprintf(tt,'%0.2f\r\n',7);
% CHORD DISTRIBUTION SWITCH (INTEGER, NON-DIM)
% CHORD DISTRIBUTION OPTIONS:
%    1 FOR CONSTANT, AIRFOILS ALIGNED ALONG THE QUARTER CHORD
%    2 FOR ELLIPTICAL, AIRFOILS ALIGNED ALONG THE QUARTER CHORD
fprintf(tt,'%g\r\n',2);
% ALLOW SWEEP; 1 FOR YES, 2 FOR NO (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',1);
% FOUR VALUES OF TIP SWEEP (REAL, DEGREES)
fprintf(tt,'%.1f\t%.1f\t%.1f\t%.1f\r\n',0,30,45,60);
% gB END POINT (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',3);
% SWEEP START POINT (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',11);
% DUCTED/UNDUCTED SWITCH; 1 FOR DUCTED, 2 FOR UNDUCTED (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',2);
% USE THE CUSTOM FLUID PROPERTIES BELOW; 1 FOR YES, 2 FOR NO (INTEGER, NON-DIM)
fprintf(tt,'%g\r\n',2);
% DENSITY (KG/M^3)
fprintf(tt,'%0.2f\r\n',1.225);
% SPEED OF SOUND (M/S)
fprintf(tt,'%0.2f\r\n',340.3);
% KINEMATIC VISCOSITY (M^2/S)
fprintf(tt,'%0.2g\r\n',1.46e-5);


fclose(tt);