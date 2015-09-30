% Given
R=1500;
V=250;
% Assumptions
sfc=[0.8; 0.7]; %[Cruise;Loiter];
E=1; %i.e. 60 min loiter time
LD=15;
AR=7;
Cd0=0.02;
e=0.7;
opts=optimoptions('fsolve','Display','off');
%% Weight Approximation Approximation

%% Fixed Weight
Wfix=(1+2+19)*225; % Attendent, Crew, Passengers

%% Fuel Use
% Mission is simple cruise
% 0-1 Takeoff 0.97
% 1-2 Climb 0.985
% 2-3 Cruise (For Range)
% 3-4 Descent 1
% 4-5 Loiter (for Time)
% 5-6 Decent 1
% 6   Landing 0.985

% Fuel ratios
Wr=exp(-R*sfc(1)/(V*(0.943*LD)));
We=exp(-E*sfc(2)/(LD));
% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

%% Empty Weight
% From Trend data: We/Wto should approximate 0.55, based on assumption that
% the aircraft will be from 20-30 thousand pounds Wto
% We_Wto=0.55;
We=@(Wt) 0.911*Wt^0.947;
%% Takeoff Weight Estimation
% Wto=Wfix+We+Wf
% 1=Wfix/Wto+(We_Wto+Wf_Wto)
% Wfix_Wto=1-We_Wto-Wf_Wto
% Wto=Wfix/Wfix_Wto;
Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-We(wt),30e3,opts);

%% Range and Takeoff
LDm=21;
Clm=fsolve(@(x) 1/LDm-(Cd0+1/(pi*AR*e)*(x^2))/x,1.5,opts); % approximated from L/D max and Cd0
p=1.2673e-3; %rho at 20,000 ft
TW=0.35;
% Grab weight loading
rng=@(x) 1.07/sfc(1)*(x/p).^0.5*(AR*e)^(1/4)/Cd0^(3/4).*(1./Wto);
Sto=@(x) 20.9*(x/(Clm*TW))+69.6*sqrt((x/(Clm*TW))*TW);
% Solve
wld=fsolve(@(x) rng(x)*Wf_Wto.*Wto-R,30,opts);
s_T=Sto(wld);
s_L=79.4*(wld/Clm)+50/tand(3);