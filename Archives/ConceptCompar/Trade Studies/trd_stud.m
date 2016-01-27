%% Trade Studies
% Looking at variation of parameters to change various output parameters
%
% Input:
%  Prop Efficiency - Nominal: 0.9
%  # of Props - Nominal: 6
%  Overall Weight - Nominal: 16,500
%
% Output:
%  Fuel Efficiency
%  Power Required

clear; clc
load('../constants.mat')

np=0.9;

props=6;
fl1=addpath('../Takeoff');
T=proppower(props,Pa,false);

TOGW=16500;


%% Domain and general equations
np_dom=linspace(0.7,1,40);
TOGW_dom=1+linspace(-0.15,0.15,40); %from -20% to 20% change
num_dom=[6,8,10,12];

%% Run
fuel_change
pow_change

%% Plotting: Fuel
figure(1); clf;
subplot(1,3,1)
plot(np_dom,100*(gm_np-gm_n0)/gm_n0)
xlabel('\eta_p'); ylabel('% \Delta \gamma')
yl1=ylim;
subplot(1,3,2)
plot(TOGW_dom*100,100*(gm_TOGW-gm_n0)/gm_n0)
title('Fuel Efficiencies')
xlabel('% \Delta TOGW')
yl2=ylim;
subplot(1,3,3)
plot(num_dom,100*(gm_nump-gm_n0)/gm_n0)
xlabel('Num of Props')
yl3=ylim;

for itr=1:3
    subplot(1,3,itr)
    ylim([min([yl1(1),yl2(1),yl3(1)]) max([yl1(2),yl2(2),yl3(2)])])
end

%% Plotting: Power
figure(2); clf;
subplot(1,3,1)
plot(np_dom,100*preq_np)
xlabel('\eta_p'); ylabel('% \Delta P_{req}')
yl1=ylim;
subplot(1,3,2)
plot(TOGW_dom*100,100*preq_TOGW)
title('Required Power for 250mph flight')
xlabel('% \Delta TOGW')
yl2=ylim;
subplot(1,3,3)
plot(num_dom,100*preq_nump)
xlabel('Num of Props')
yl3=ylim;

for itr=1:3
    subplot(1,3,itr)
    ylim([min([yl1(1),yl2(1),yl3(1)]) max([yl1(2),yl2(2),yl3(2)])])
end

%% Revert Path
path(fl1)