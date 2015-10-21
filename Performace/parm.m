%% Parameters
% This script assings variables to workspace to define the parameters and
% goals that the Q1 will meet, as decided upon by the team.

% Mission
V_c=265;
% RFP is 250 mph, so we bumped to 265 mph cruise velocity
p_c=1.1043e-3;
% airdensity at cruise altitude of 24,000 ft
sfc=0.5;
% Specifc fuel consumption

% Weight
We=9087.8; % lbs empty/dry weight of aircraft
Wf=2663.3; % lbs max fuel capactiy

% Dimensions
AR=10;
S=420.5;  % ft^2, makes WS at max WTO approx 40;
b=64.81;    % ft, span

% Aerodynamic Performance
e=0.8;
LD=18;
% Lift over drag at cruise conditions

% Power
P=1550; % hp, provided by all engines

% Takeoff conditions
CLg=1.7;
% Lift coefficient for takeoff (slats+flaps)
CDg=0.05;
% Drag coefficient for takeoff (slats+flaps)
mu=0.04;
% Should be able to take off from "firm turf"
p_sl=2.3769e-3;
% airdensity at sea level altitude
T0=12e3;
% lbf, static thrust
VTO=1.2*105;
% Takeoff Velocity, at 1.2 * 105 ft/s (stall speed)