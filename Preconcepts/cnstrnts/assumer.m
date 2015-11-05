<<<<<<< HEAD
%% Requirements
% Range
R=800*1.151;  % miles, 800 nautical miles

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm

% Cruise Speed
V_c=265;  % mph

% Service Ceiling
%     100 ft/min Rate of Climb
h_sc=28000; % ft
p_sc=.958e-3;   % slugs per ft^3

% Takeoff Distance
s_T=3000;   % ft

%% Initial Performance Constants
sfc=0.5;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0.25;     % i.e. 25 min loiter time
LD=17;      % Max L/D, used for cruise
AR=10;      % Aspect Ratio
Cd0=0.022;  % 
e=0.8;      % Oswald Efficency

% Convience Constants
K=1/(e*pi*AR);
V_md=@(ws,p) sqrt(2*ws/(p*sqrt(Cd0/K)));
V_mp=@(ws,p) sqrt(2*ws/p)*(K/3*Cd0)^(1/4);
p_sl=2.3769e-3; %slugs/ft^3, sea level density

% Conditional Constants
Cl_max=1.8;  % Max C_L for takeoff
V_stall=65*1.688; % Stall speed in ft/s, Sea Level, max 65 knots


%% Goals
% Range, 1500 nm
% Payload, 19 pass+crew+attend+500lbs
% Cruise Speed 300 mph
% Cruise Ceiling, (300 ft/min) 20,000 ft
h_c=20000;
p_c=1.267e-3;  % slugs per ft^3
=======
%% Requirements
% Range
R=800*1.151;  % miles, 800 nautical miles

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm

% Cruise Speed
V_c=265;  % mph

% Service Ceiling
%     100 ft/min Rate of Climb
h_sc=28000; % ft
p_sc=.958e-3;   % slugs per ft^3

% Takeoff Distance
s_T=3000;   % ft

%% Initial Performance Constants
sfc=0.5;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0.25;     % i.e. 25 min loiter time
LD=17;      % Max L/D, used for cruise
AR=10;      % Aspect Ratio
Cd0=0.022;  % 
e=0.8;      % Oswald Efficency

% Convience Constants
K=1/(e*pi*AR);
V_md=@(ws,p) sqrt(2*ws/(p*sqrt(Cd0/K)));
V_mp=@(ws,p) sqrt(2*ws/p)*(K/3*Cd0)^(1/4);
p_sl=2.3769e-3; %slugs/ft^3, sea level density

% Conditional Constants
Cl_max=1.8;  % Max C_L for takeoff
V_stall=65*1.688; % Stall speed in ft/s, Sea Level, max 65 knots


%% Goals
% Range, 1500 nm
% Payload, 19 pass+crew+attend+500lbs
% Cruise Speed 300 mph
% Cruise Ceiling, (300 ft/min) 20,000 ft
h_c=20000;
p_c=1.267e-3;  % slugs per ft^3
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
% Landing Distance<3000 ft, also one-engine failiure