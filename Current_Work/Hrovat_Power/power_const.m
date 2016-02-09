%% Power Constants
% Hrovat's information specifci to the power plants.

%   Generator
% Avalibe power for the propellors
Pa=1000*550;    
% Specific Fuel Consumption, lb_fuel/sec
SFC_eq=@(P) 0.345*P/3600; % https://en.wikipedia.org/wiki/Brake_specific_fuel_consumption for junkeres jumo 204 engine


%% Motor Constants
% Ideal RPM
rpm=2500;