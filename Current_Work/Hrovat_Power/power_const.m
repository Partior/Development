%% Power Constants
% Hrovat's information specifci to the power plants.

%   Generator
% Avalibe power for the propellors
Pa=1050; % conversion from kW to lbf ft/s

%% Motor Constants
% Ideal RPM
rpm=2000;

% NEW DATA
n_motor=0.95;   %Siemens Electric motor efficiency

% Specific Fuel Consumption, lb_fuel/sec
% SFC_eq=@(P) 0.345*P/3600; % https://en.wikipedia.org/wiki/Brake_specific_fuel_consumption for junkeres jumo 204 engine

SFC_eq=@(P) 0.4*(P/n_motor)/3600;