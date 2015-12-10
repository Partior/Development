%% PropWash Constants

% Weight
Wfix=@(px) 225*(3+px);
We=9064.1;
Wf=1307.5;  
W0=@(pw) Wfix(pw)+We+Wf;

% Density and Wing Planeform
p=@(h) 2.3769e-3*exp(-3.2e-5*h);
S=240;
AR=15;
Cd0=0.022;
e=1.78*(1-0.045*AR^0.68)-0.64; %eq 10b - http://faculty.dwc.edu/sadraey/Chapter%203.%20Drag%20Force%20and%20its%20Coefficient.pdf
K=1/(AR*e*pi);

% Power
Pa=1000*550;

% Engines
n=8;
SFC_eq=@(P) 0.345*P/3600; % lb_fuel/sec for a power setting
% https://en.wikipedia.org/wiki/Brake_specific_fuel_consumption for
% junkeres jumo 204 engine