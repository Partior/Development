<<<<<<< HEAD
%% Weight Approximation Approximation

%% Fixed Weight
Wfix=(1+2+19)*225; % Attendent, Crew, Passengers

%% Fuel Use
% Mission is simple cruise
% 0-1 Takeoff
% 1-2 Climb
% 2-3 Cruise
% 3-4 Descent
% 4-5 Loiter
% 5-6 Decent
% 6   Landing

% W(i+1)/W(i)
% 0 0.97
% 1 0.985
% 2 for 1000 miles Range
% 3 1
% 4 for 60 min Loiter
% 5 0.985

% Given
R=1000;
E=1; %i.e. 60 min
V=250;

% Assumptions
sfc=[0.9; 0.8]; %[Cruise;Loiter];
LD=17;

% Fuel ratios
Wr=exp(-R*sfc(1)/(V*(0.943*LD)));
We=exp(-E*sfc(2)/(LD));

% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

%% Empty Weight

% From Trend data: We/Wto should approximate 0.55, based on assumption that
% the aircraft will be from 20-30 thousand pounds Wto
We_Wto=0.50; %%ALTERATION, used to be 0.55

%% Takeoff Weight Estimation

% Wto=Wfix+We+Wf
% 1=Wfix/Wto+(We_Wto+Wf_Wto)
% Wfix_Wto=1-We_Wto-Wf_Wto
% Wto=Wfix/Wfix_Wto;

Wto=Wfix/(1-We_Wto-Wf_Wto);
=======
%% Weight Approximation Approximation

%% Fixed Weight
Wfix=(1+2+19)*225; % Attendent, Crew, Passengers

%% Fuel Use
% Mission is simple cruise
% 0-1 Takeoff
% 1-2 Climb
% 2-3 Cruise
% 3-4 Descent
% 4-5 Loiter
% 5-6 Decent
% 6   Landing

% W(i+1)/W(i)
% 0 0.97
% 1 0.985
% 2 for 1000 miles Range
% 3 1
% 4 for 60 min Loiter
% 5 0.985

% Given
R=1000;
E=1; %i.e. 60 min
V=250;

% Assumptions
sfc=[0.9; 0.8]; %[Cruise;Loiter];
LD=17;

% Fuel ratios
Wr=exp(-R*sfc(1)/(V*(0.943*LD)));
We=exp(-E*sfc(2)/(LD));

% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

%% Empty Weight

% From Trend data: We/Wto should approximate 0.55, based on assumption that
% the aircraft will be from 20-30 thousand pounds Wto
We_Wto=0.50; %%ALTERATION, used to be 0.55

%% Takeoff Weight Estimation

% Wto=Wfix+We+Wf
% 1=Wfix/Wto+(We_Wto+Wf_Wto)
% Wfix_Wto=1-We_Wto-Wf_Wto
% Wto=Wfix/Wfix_Wto;

Wto=Wfix/(1-We_Wto-Wf_Wto);
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
