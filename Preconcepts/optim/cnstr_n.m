<<<<<<< HEAD
%% WARNING!!!
%
%
%
%   This modified Script is to be used only with latticeout.m!
%
%
%
%
%


%% Gross Weight Takeoff Estimation
% Used to provide Contraint producer with estimated gross takeoff weight,
% assumptions for simple cruise

% Mission for fuel wieght is simple cruise
%     0-1 Takeoff 0.97
%     1-2 Climb 0.985
%     2-3 Cruise (For Range)
%     3-4 Descent 1
%     4-5 Loiter (for Time)
%     5-6 Decent 1
%     6   Landing 0.985

% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-R*sfc/(V_c*(0.943*LD)));
We=exp(-E*sfc/(LD));
% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;

% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));

%% Ranges for W/S
WSD=linspace(5,60,25);

%% Limits on W/S
% Wing-loading minimum to meet required Range
WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));

% Wing-loading min to meet C_L_max and V_stall assumptions
WS_s=0.5*p_c*V_stall^2*Cl_max;

% Limit on W/S for Landing Distance within required distance, 3 degree
% angle of approach
WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
    50,optimoptions('fsolve','display','off'));
%% Takeoff Distance
% W/S and T/W to takeoff at required distance
s_tm=zeros(1,length(WSD));
for a=1:length(WSD)
    s_tm(a)=fsolve(@(tw) ...
        s_T-(20.9*(WSD(a)/(Cl_max*tw))+69.6*sqrt(WSD(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end

%%
V_c=V_c*1.46666; %Transfere to ft/s for next series of equations

%% Cruise Conditions
% For both cruise and climb conditions, leaving off 1/g(dV/dt) term
TW_c=@(ws,p,V,n,hdot)...
    (0.5*p*V.^2)*Cd0./ws+K*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);

% For Straight, Level Flight at cruise conditions
TW_cruise=TW_c(WSD,p_c,V_c,1,0);

% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=TW_c(WSD,p_sc,V_mp(WSD,p_sc),1,100/60);

% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=TW_c(WSD,p_c,V_mp(WSD,p_c),1,300/60);

% Maneuver at Sea Level, cruise conditions, 2.5 g's
TW_man=TW_c(WSD,p_sl,V_c,2.5,0);

%% Graphic Output
% Axis of WS and TW

figure(f_det);
axes(aTW);
cla(aTW)
plot(aTW,WSD,s_tm,'b-')       % Takeoff Distance Req
plot(aTW,WSD,TW_cruise,'b--') % Cruise Req
plot(aTW,WSD,TW_serv,'g--')   % Service Ceiling Req
plot(aTW,WSD,TW_cc,'k--')     % Cruise Ceiling Req
plot(aTW,WSD,TW_man,'r-.')    % Maneuver Req


aTW.XLimMode='auto';
aTW.YLimMode='auto';
% Min W/S Req for range and stall
ym=ylim;
plot(aTW,WS_r*ones(1,2),ym,'k:')
plot(aTW,WS_s*ones(1,2),ym,'r:')
plot(aTW,WS_l*ones(1,2),ym,'b:')


D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);
%% Optimum Output
plot(aTW,posout(1),D(posout(1),V_c,p_c)/Wto,...
    'LineStyle','none',...
    'Marker','d',...
    'MarkerSize',13,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','y')
%% Visual Adjustments
% Size Matters
legend({'Takeoff',...
    'Cruise','Ceiling_{service}','Ceiling_{cruise}','2.5g @ SL',...
    'Range','Stall','Landing'},...
    'Location','north')

%% Axis, Title and Text
% Text Output
xm=xlim;
axes(aTW)
text(0.98*xm(2),0.05*ym(2),sprintf('W_{TO}=%6.0f lbs',Wto),...
    'horizontalAlignment','right','verticalAlignment','bottom','Parent',aTW)
text(WS_r,0.95*ym(2),sprintf('%0.0f nm',R/1.151),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_s,0.90*ym(2),sprintf('%0.0f KTAS',V_stall/1.688),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_l,0.95*ym(2),sprintf('%0.0f ft',s_T),...
    'horizontalAlignment','right','verticalAlignment','top')
=======
%% WARNING!!!
%
%
%
%   This modified Script is to be used only with latticeout.m!
%
%
%
%
%


%% Gross Weight Takeoff Estimation
% Used to provide Contraint producer with estimated gross takeoff weight,
% assumptions for simple cruise

% Mission for fuel wieght is simple cruise
%     0-1 Takeoff 0.97
%     1-2 Climb 0.985
%     2-3 Cruise (For Range)
%     3-4 Descent 1
%     4-5 Loiter (for Time)
%     5-6 Decent 1
%     6   Landing 0.985

% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-R*sfc/(V_c*(0.943*LD)));
We=exp(-E*sfc/(LD));
% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;

% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));

%% Ranges for W/S
WSD=linspace(5,60,25);

%% Limits on W/S
% Wing-loading minimum to meet required Range
WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));

% Wing-loading min to meet C_L_max and V_stall assumptions
WS_s=0.5*p_c*V_stall^2*Cl_max;

% Limit on W/S for Landing Distance within required distance, 3 degree
% angle of approach
WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
    50,optimoptions('fsolve','display','off'));
%% Takeoff Distance
% W/S and T/W to takeoff at required distance
s_tm=zeros(1,length(WSD));
for a=1:length(WSD)
    s_tm(a)=fsolve(@(tw) ...
        s_T-(20.9*(WSD(a)/(Cl_max*tw))+69.6*sqrt(WSD(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end

%%
V_c=V_c*1.46666; %Transfere to ft/s for next series of equations

%% Cruise Conditions
% For both cruise and climb conditions, leaving off 1/g(dV/dt) term
TW_c=@(ws,p,V,n,hdot)...
    (0.5*p*V.^2)*Cd0./ws+K*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);

% For Straight, Level Flight at cruise conditions
TW_cruise=TW_c(WSD,p_c,V_c,1,0);

% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=TW_c(WSD,p_sc,V_mp(WSD,p_sc),1,100/60);

% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=TW_c(WSD,p_c,V_mp(WSD,p_c),1,300/60);

% Maneuver at Sea Level, cruise conditions, 2.5 g's
TW_man=TW_c(WSD,p_sl,V_c,2.5,0);

%% Graphic Output
% Axis of WS and TW

figure(f_det);
axes(aTW);
cla(aTW)
plot(aTW,WSD,s_tm,'b-')       % Takeoff Distance Req
plot(aTW,WSD,TW_cruise,'b--') % Cruise Req
plot(aTW,WSD,TW_serv,'g--')   % Service Ceiling Req
plot(aTW,WSD,TW_cc,'k--')     % Cruise Ceiling Req
plot(aTW,WSD,TW_man,'r-.')    % Maneuver Req


aTW.XLimMode='auto';
aTW.YLimMode='auto';
% Min W/S Req for range and stall
ym=ylim;
plot(aTW,WS_r*ones(1,2),ym,'k:')
plot(aTW,WS_s*ones(1,2),ym,'r:')
plot(aTW,WS_l*ones(1,2),ym,'b:')


D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);
%% Optimum Output
plot(aTW,posout(1),D(posout(1),V_c,p_c)/Wto,...
    'LineStyle','none',...
    'Marker','d',...
    'MarkerSize',13,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','y')
%% Visual Adjustments
% Size Matters
legend({'Takeoff',...
    'Cruise','Ceiling_{service}','Ceiling_{cruise}','2.5g @ SL',...
    'Range','Stall','Landing'},...
    'Location','north')

%% Axis, Title and Text
% Text Output
xm=xlim;
axes(aTW)
text(0.98*xm(2),0.05*ym(2),sprintf('W_{TO}=%6.0f lbs',Wto),...
    'horizontalAlignment','right','verticalAlignment','bottom','Parent',aTW)
text(WS_r,0.95*ym(2),sprintf('%0.0f nm',R/1.151),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_s,0.90*ym(2),sprintf('%0.0f KTAS',V_stall/1.688),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_l,0.95*ym(2),sprintf('%0.0f ft',s_T),...
    'horizontalAlignment','right','verticalAlignment','top')
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
ylim(ym)