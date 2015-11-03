<<<<<<< HEAD
%% Parameters
% This script assings variables to workspace to define the parameters and
% goals that the Q1 will meet, as decided upon by the team.

% Mission
V_c=250;
% RFP is 250 mph, so we bumped to 265 mph cruise velocity
p_c=1.1043e-3;
% airdensity at cruise altitude of 24,000 ft
sfc=0.55;
% Specifc fuel consumption

% Weight
% We=9087.8; % lbs empty/dry weight of aircraft
% Wf=2663.3; % lbs max fuel capactiy
We=8717;
Wf=2503;

% Dimensions
AR=10;
S=425;  % ft^2, makes WS at max WTO approx 40;
b=65.2;    % ft, span

% Aerodynamic Performance
e=0.75;
LD=21;
% Lift over drag at cruise conditions

% Power
P=1000; % hp, provided by all engines

% Takeoff conditions
CLg=1.7;
% Lift coefficient for takeoff (slats+flaps)
CDg=0.05;
% Drag coefficient for takeoff (slats+flaps)
mu=0.04;
% Should be able to take off from "firm turf"
p_sl=2.3769e-3;
% airdensity at sea level altitude
T0=1.1+04;
% lbf, static thrust
VTO=1.2*110;
=======
%% Parameters
% This script assings variables to workspace to define the parameters and
% goals that the Q1 will meet, as decided upon by the team.

% Mission
V_c=250;
% RFP is 250 mph, so we bumped to 265 mph cruise velocity
p_c=1.1043e-3;
% airdensity at cruise altitude of 24,000 ft
sfc=0.55;
% Specifc fuel consumption

% Weight
% We=9087.8; % lbs empty/dry weight of aircraft
% Wf=2663.3; % lbs max fuel capactiy
We=8717;
Wf=2503;

% Dimensions
AR=10;
S=425;  % ft^2, makes WS at max WTO approx 40;
b=65.2;    % ft, span

% Aerodynamic Performance
e=0.75;
LD=21;
% Lift over drag at cruise conditions

% Power
P=1000; % hp, provided by all engines

% Takeoff conditions
CLg=1.7;
% Lift coefficient for takeoff (slats+flaps)
CDg=0.05;
% Drag coefficient for takeoff (slats+flaps)
mu=0.04;
% Should be able to take off from "firm turf"
p_sl=2.3769e-3;
% airdensity at sea level altitude
T0=1.1+04;
% lbf, static thrust
VTO=1.2*110;
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
% Takeoff Velocity, at 1.2 * 105 ft/s (stall speed)