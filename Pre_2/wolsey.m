%%   Enviorment
% Sea level Constants
Tsl=288.16; % Kelvin
Psl=1.0132e5; %Pa
psl=1.225; %kg/m^3
g0=9.8067; %m/s^2
R=287.0368; %Nm/kg K

% Mach Number
gm=1.4; % 
a=@(T_a) sqrt(gm*R*T_a);

%% Assumptions about plane
% Fligth Paramters
Cd0=0.02;
% Coefficent Properties
% Runs for:
%     Cl_alpha
%     Cl & Cd min drag
%     Cl & Cd min power

% Cruise Paramters
    % Reuired
R=1000; % Range, miles
E=0.25; % Endurance, 15 min loiter
V=250;  % mph cruise speed
    % Assumptions
e=0.75; % Lift Distrubution efficiency
AR=10;  % Aspect Ratio, from trends (7-11)
p=

LD_cruise=19; % L/D max is for cruise conditions


% Weight Assumptions
    % Required
Wfix=(1+2+19)*225; % Attendent, Crew, Passengers
    % Fuel ratios
Wr=exp(-R*sfc/(V*(0.943*LD))); % Weight fraction of range 
We=exp(-E*sfc/(LD)); % Weight fraction of Loiter
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);
    % Empty Weight
We=@(Wt) 0.911*Wt^0.947; % Emtpy weight from trends

% Specifc Fuel consumption for ICE-Propellers ranges from 0.4 to 0.5
sfc=0.5;

% Constant Power aircraft
% Power at altitude = Power_SL * (p/psl)^x; where x can be taken as 1

% Power Required
