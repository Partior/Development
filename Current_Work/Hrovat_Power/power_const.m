%% Power Constants
% Hrovat's information specifci to the power plants.

%   Generator
% Avalibe power for the propellors
Pa=900*737.562149-....% conversion from kW to lbf ft/s
    150*737.562149;     % assuming it takes 60 kW to produce power for avionics
% Specific Fuel Consumption, lb_fuel/sec
SFC_eq=@(P) 0.345*P/3600; % https://en.wikipedia.org/wiki/Brake_specific_fuel_consumption for junkeres jumo 204 engine

% Going under assumption now that it acts like a turbo fan
SFC_eq=@(P) 0.5*P/3600;

%% Motor Constants
% Ideal RPM
rpm=2000;

% NEW DATA
n_motor=0.95;   %Siemens Electric motor efficiency