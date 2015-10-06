%% Power to Constraints
% Designed to take T/W data from Constraint Graphic, and transform that to
% Power required at Various Altitudes
close all; clear; clc
cnstr

%% Cruise Conditions
% Equilvant Power to various altitudes 
D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);

% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSdom,V_md(WSdom,p_sc),p_sc).*V_md(WSdom,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_md(WSdom,p_c),p_sc).*V_md(WSdom,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSdom,V_c,p_sl)*V_c/(p_sl/p_sl);

% Testing Takeoff Power required
Preq_TO=(s_tm*Wto)*(V_stall*1.3);


%% Graphic Output
f2=figure(2); clf
hold on
plot(WSdom,Preq_cruise/550,'b--')
plot(WSdom,Preq_serv/550,'g--')
plot(WSdom,Preq_cc/550,'k--')
plot(WSdom,Preq_man/550,'r-.')
plot(WSdom,Preq_TO/550,'b-')

legend({'Cruise','Ceiling_{Service}','Ceiling_{Cruise}','2.5g @ SL','Takeoff'})
xlabel('Wing Loading, lbs/ft^2')
ylabel('Required Power, hp')
title('Partior Q==1: Power Requirements')