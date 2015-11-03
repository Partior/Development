% %%   Enviorment
% % Sea level Constants
% Tsl=288.16; % Kelvin
% Psl=1.0132e5; %Pa
% psl=1.225; %kg/m^3
% g0=9.8067; %m/s^2
% R=287.0368; %Nm/kg K
% 
% % Mach Number
% gm=1.4; % 
% a=@(T_a) sqrt(gm*R*T_a);

%% Becuase
opts=optimoptions('fsolve','Display','off');

%% Assumptions about plane
% Fligth Paramters
Cd0=0.022;
% Coefficent Properties
% Runs for:
%     Cl_alpha
%     Cl & Cd min drag
%     Cl & Cd min power

% Cruise Paramters
    % Reuired
R=800*1.15078; % Range, miles (from 800 nm)
E=0.25; % Endurance, 15 min loiter
V=250;  % mph cruise speed
p=1.26720e-03; % slugs/ft^3 at 20000 ft altitude
    % Assumptions
e=0.75; % Lift Distrubution efficiency
AR=10;  % Aspect Ratio, from trends (7-11)
K=1/(e*pi*AR);

LD=19; % L/D max is for cruise conditions
Cl_max=1.5; % for Stall

% Weight Assumptions
    % Required
Wfix=(1+2+19)*225; % Attendent, Crew, Passengers
    % Fuel ratios
sfc=0.5;    % Specifc Fuel consumption for ICE-Propellers 
%     ranges from 0.4 to 0.5
Wr=exp(-R*sfc/(V*(0.943*LD))); % Weight fraction of range 
We=exp(-E*sfc/(LD)); % Weight fraction of Loiter
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);
    % Empty Weight
We=@(Wt) 0.911*Wt^0.947; % Emtpy weight from trends

Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-We(wt),30e3,opts);
% Constant Power aircraft
% Power at altitude = Power_SL * (p/psl)^x; where x can be taken as 1

% Power Required
%% Constraint Analysis
wsdom=[10 70];
% At cruise altitude
qc=0.5*p*V^2; %Dynamic pressure
    qcSI=qc/0.020885434; % N/m^2 to lbf/ft^2
TW_SLFlight=@(WS) qcSI*Cd0/(WS)+K/qcSI*WS;
[x_cruise,y_cruise]=fplot(@(ws) TW_SLFlight(ws),wsdomI);

% Climb defined by service ceiling set to 8500 meters
p_cs=9.6e-4; % slugs per cubic foot
p_csSI=p_cs*1; % NEED TO ADJUST
V_cs=@(WS) sqrt(2*WS/p_cs)*(K/(3*Cd0))^(1/4);  % m/s, defined by V_minpower at altitude
q_clmb_serv=@(WS) 0.5*p_cs*V_cs(WS)^2;
% 0.508 m/s is service ceiling 100ft/min
% 1.524 m/s is cruise ceiling  300ft/min
Preq=@(WS) Wto*(4*Cd0)/(sqrt(3*Cd0/K))*sqrt(2*WS/(p_cs*(sqrt(3*Cd0/K)))); % Power required at min power for given W and WS
TW_clmb_serv=@(WS) fsolve(@(TW) 100-TW*V_cs(WS)+Preq(WS,W)/Wto,0.4,opts);
% Range to Wingloading, used to output Wto for TW_clmb
ws_range=@(WS) Wf_Wto*1.07/(sfc)*sqrt(WS/((p_cs)*Cd0^(3/4)))*(AR*e)^(1/4);
ws_p_range=fsolve(@(ws) ws_range(ws)-R,500,opts); %Min w/s for range

%% Plotting
figure(1); cla; hold on
plot(x_cruise,y_cruise,'b-')
% plot(x_serv_ceil,y_serv_ceil,'b-.')
% legend({'Cruise','Service Ceiling'})
ym=ylim;
plot(ws_p_range*ones(1,2),ym,'k:')

xlabel('W/S')
ylabel('T/W')