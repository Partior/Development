<<<<<<< HEAD
%% Power to Constraints
% Designed to take T/W data from Constraint Graphic, and transform that to
% Power required at Various Altitudes
close all; clear; clc
cnstr

%% Cruise Conditions
% Equilvant Power to various altitudes 
D=@(ws,v,p) Cd0*0.5*p*v.^2.*(ws)+K*ws./(0.5*p*v.^2);

% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSdom,V_mp(WSdom,p_sc),p_sc).*V_mp(WSdom,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_mp(WSdom,p_c),p_sc).*V_mp(WSdom,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSdom,V_c,p_sl)*V_c/(p_sl/p_sl);


% Drag for Power
            D=@(ws,V,p,dhdt,n) (Wto*dhdt)./V + (Cd0*V.^2*Wto*p)./(2*ws) + (2*K*Wto*n^2*ws)./(V.^2*p);

%             % Calculations for Power
%             % Straight, Level Flight
%             Preq_cruise=@(ws) D(ws,V_c,p_c,0,1)*V_c/(p_c/p_sl);
%             % Service Ceiling
%             Preq_serv=@(ws) (D(ws,V_mp(ws,p_sc),p_sc,100/60,1).*V_mp(ws,p_sc)/(p_sc/p_sl));
%             % Cruise Ceiling
%             Preq_cc=@(ws) D(ws,V_mp(ws,p_c),p_c,300/60,1).*V_mp(ws,p_c)/(p_c/p_sl);
%             % 2.5g Maneuer at Sea Level
%             Preq_man=@(ws) D(ws,V_c,p_sl,0,2.5)*V_c/(p_sl/p_sl);


% Testing Takeoff Power required
Preq_TO=(s_tm*Wto)*(V_stall*1.3);


%% Graphic Output
f2=figure(2); clf
hold on
% plot(WSdom,Preq_cruise(WSdom)/550,'b--')
% plot(WSdom,Preq_serv(WSdom)/550,'g--')
% plot(WSdom,Preq_cc(WSdom)/550,'k--')
% plot(WSdom,Preq_man(WSdom)/550,'r-.')
% plot(WSdom,Preq_TO/550,'b-')

plot(WSdom,Preq_cruise/550,'b--')
plot(WSdom,Preq_serv/550,'g--')
plot(WSdom,Preq_cc/550,'k--')
plot(WSdom,Preq_man/550,'r-.')
plot(WSdom,Preq_TO/550,'b-')

legend({'Cruise','Ceiling_{Service}','Ceiling_{Cruise}','2.5g @ SL','Takeoff'})
xlabel('Wing Loading, lbs/ft^2')
ylabel('Required Power, hp')
=======
%% Power to Constraints
% Designed to take T/W data from Constraint Graphic, and transform that to
% Power required at Various Altitudes
close all; clear; clc
cnstr

%% Cruise Conditions
% Equilvant Power to various altitudes 
D=@(ws,v,p) Cd0*0.5*p*v.^2.*(ws)+K*ws./(0.5*p*v.^2);

% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSdom,V_mp(WSdom,p_sc),p_sc).*V_mp(WSdom,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_mp(WSdom,p_c),p_sc).*V_mp(WSdom,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSdom,V_c,p_sl)*V_c/(p_sl/p_sl);


% Drag for Power
            D=@(ws,V,p,dhdt,n) (Wto*dhdt)./V + (Cd0*V.^2*Wto*p)./(2*ws) + (2*K*Wto*n^2*ws)./(V.^2*p);

%             % Calculations for Power
%             % Straight, Level Flight
%             Preq_cruise=@(ws) D(ws,V_c,p_c,0,1)*V_c/(p_c/p_sl);
%             % Service Ceiling
%             Preq_serv=@(ws) (D(ws,V_mp(ws,p_sc),p_sc,100/60,1).*V_mp(ws,p_sc)/(p_sc/p_sl));
%             % Cruise Ceiling
%             Preq_cc=@(ws) D(ws,V_mp(ws,p_c),p_c,300/60,1).*V_mp(ws,p_c)/(p_c/p_sl);
%             % 2.5g Maneuer at Sea Level
%             Preq_man=@(ws) D(ws,V_c,p_sl,0,2.5)*V_c/(p_sl/p_sl);


% Testing Takeoff Power required
Preq_TO=(s_tm*Wto)*(V_stall*1.3);


%% Graphic Output
f2=figure(2); clf
hold on
% plot(WSdom,Preq_cruise(WSdom)/550,'b--')
% plot(WSdom,Preq_serv(WSdom)/550,'g--')
% plot(WSdom,Preq_cc(WSdom)/550,'k--')
% plot(WSdom,Preq_man(WSdom)/550,'r-.')
% plot(WSdom,Preq_TO/550,'b-')

plot(WSdom,Preq_cruise/550,'b--')
plot(WSdom,Preq_serv/550,'g--')
plot(WSdom,Preq_cc/550,'k--')
plot(WSdom,Preq_man/550,'r-.')
plot(WSdom,Preq_TO/550,'b-')

legend({'Cruise','Ceiling_{Service}','Ceiling_{Cruise}','2.5g @ SL','Takeoff'})
xlabel('Wing Loading, lbs/ft^2')
ylabel('Required Power, hp')
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
title('Partior Q==1: Power Requirements')