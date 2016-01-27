%% PropWash Constants
% All constants used by the /PropWash/ scripts to run and develop unique
% V-H and fuel useage diagrams

%% ATMOSPHERE
p=@(h) 2.3769e-3*exp(-3.2e-5*h);            % air density at altitude h(ft)
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;      % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

%% WEIGHT
Wfix=@(px) 225*(3+px);      % Payload weight, as function of # passengers
We=9064.1;                  % Empty (or Structure) weight
Wf=1307.5;                  % Fuel weight, takes up approx 200 gallons of volume
W0=@(pw) Wfix(pw)+We+Wf;    % Total

%% MAIN WING
%   Planeform
S=240;
AR=15;
b=sqrt(AR*S);   % or 60.0 ft
chrd=S/b;       % or 4.00 ft
e=1.78*(1-0.045*AR^0.68)-0.64; %eq 10b - http://faculty.dwc.edu/sadraey/Chapter%203.%20Drag%20Force%20and%20its%20Coefficient.pdf
K=1/(AR*e*pi);

%   Airfoil
incd=6;     % incidence angle of wing strucutre
airfoil_polar_file='naca_polar.txt';  % file name of Airfoil Cl/Cd polar data as run by XFOIL

%% FUSELAGE
%   Wetted Area and Fuselage Wetted Area
S_wet=4.5*S;        % from Dr. Raj Lecture 4
S_wet_f=S_wet-2*S;  % minus both sides of the wings
cab_diam=9;         % cabin diamater, ft

%% POWER
%   Generator
Pa=1000*550;
SFC_eq=@(P) 0.345*P/3600; % lb_fuel/sec for a power setting % https://en.wikipedia.org/wiki/Brake_specific_fuel_consumption for junkeres jumo 204 engine

%   Propellers
n=8;        % number of propellers
rpm=2500;   % max rpm rating
% Radius of propellers currently set by script /prop_T.m

