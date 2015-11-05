<<<<<<< HEAD
%% Make constants

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm
% Initial Performance Constants
SFC=0.55;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0;     % i.e. 25 min loiter time
cd0=0.02;  % 
e=0.72;      % Oswald Efficency
% Cruise Enviromental Conditions
% Takeoff Distance
s_T=3000;   % ft
% WS Restraint Constants
Cl_max=1.7;  % Max C_L for takeoff
V_stall=65*1.688; % Stall speed in ft/s, Sea Level, max 75 knots
% Convience Conditions
V_md=@(ws,p,K) sqrt(2*ws./(p*sqrt(cd0./K)));
V_mp=@(ws,p,K) sqrt(2*ws/p).*(K/3*cd0).^(1/4);
p_sl=2.3769e-3; %slugs/ft^3, sea level density
% Service Ceiling
p_sc=.958e-3;   % slugs per ft^3

R=800*1.151;
=======
%% Make constants

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm
% Initial Performance Constants
SFC=0.55;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0;     % i.e. 25 min loiter time
cd0=0.02;  % 
e=0.72;      % Oswald Efficency
% Cruise Enviromental Conditions
% Takeoff Distance
s_T=3000;   % ft
% WS Restraint Constants
Cl_max=1.7;  % Max C_L for takeoff
V_stall=65*1.688; % Stall speed in ft/s, Sea Level, max 75 knots
% Convience Conditions
V_md=@(ws,p,K) sqrt(2*ws./(p*sqrt(cd0./K)));
V_mp=@(ws,p,K) sqrt(2*ws/p).*(K/3*cd0).^(1/4);
p_sl=2.3769e-3; %slugs/ft^3, sea level density
% Service Ceiling
p_sc=.958e-3;   % slugs per ft^3

R=800*1.151;
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
save('constants.mat')