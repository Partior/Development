%% Sensitivity Calculations, Output script
% Look at sensitvity changes in Fuel Consumption at Cruise for various
% parameter changes, namely:
%   Change in Weight
%   Change in Propeller Efficiency
%   Change in Required Power (from Drag changes)
%
% Specifically, this script combines the overall analysis of individual
% scripts to produce a graphically output.

clear; close all; clc
prop_const;
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);
airfoil_polar
cd_new
equations_wash

gmma=@(v,P) v/SFC_eq(P)/5280;   % Fuel Consumption

% Cruise Conditions
v=250*1.4666;
h=25e3;
ne=2; % Just Cruise engines
% Initial values before chagnge-
taoa0=fsolve(@(rr) L(rr,h,v,ne)-W0(19),0,optimoptions('fsolve','display','off'));
D_cr0=D(taoa0,h,v,ne);
P_cr0=fsolve(@(pp) T(v,h,pp,2)-D_cr0,600*550,optimoptions('fsolve','display','off'))/550;
gm0=gmma(v,P_cr0);

%% Change in Weight
% Look at the following changes in Weight:
% As of 24 FEB, [.1,.5,1,2,5,10,20]% of TOGW approximate the following:
%
% 15 lbs
% 75 lbs
% 150 lbs
% 300 lbs
% 775 lbs
% 1500 lbs
% 3000 lbs

dW=[15;75;150;300;775;1500;3000]; % both positive and negitive are accounted for

sen_weight

%% Change in Prop Eff
% Look at the following changes in prop eff:
% From an initial guesstamate of n_p ~ 90%
%
% 60 : 95

dNp=linspace(75,95,11)';
Np0=90;

sen_prop

%% Change in Drag Effects
% Look at following changes in drag force at cruise:
% As of 24 FEB, drag at cruise is approx: 385.4207 lbs
% For similar percentage changes of drag approx:
%
% 0.5 lbs
% 2 lbs
% 4 lbs
% 7.5 lbs
% 20 lbs
% 40 lbs
% 75 lbs

dD=[0.5;2;4;7.5;20;40;75];    % both positive and negitive are accounted for

sen_drag

%% Graphical Output

ff=figure;
clf
sz=[8.5 4];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff,'Units','inches','Position',[2 2 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
plot(dW/W0(19)*100,gmW-gm0,'LineWidth',2)
plot(dNp-Np0,gmN-gm0,'LineWidth',2)
plot(dD/384.42*100,gmD-gm0,'LineWidth',2)

legend({'Weight';'Prop Eff';'Drag'},'FontSize',12)
title('Sensitivity Study to Fuel Comsumption')
aa.Title.FontSize=14;
xlabel('Percent Change in Variable')
aa.XLabel.FontSize=14;
aa.FontSize=12;
ylabel('Change in Fuel Consumption, miles/lb_{fuel}')
aa.YLabel.FontSize=14;

