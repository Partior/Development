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

D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);

% Straight, Level Flight
Preq_cruise=D(WSD,V_c,p_c)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSD,V_md(WSD,p_sc),p_sc).*V_md(WSD,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSD,V_md(WSD,p_c),p_c).*V_md(WSD,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSD,V_c,p_sl)*V_c/(p_sl/p_sl);

%% Graphic Output
figure(f_det);
axes(aPW);
cla(aPW)
aPW.XLimMode='auto';
aPW.YLimMode='auto';
plot(aPW,WSD,Preq_cruise/550,'b--')
plot(aPW,WSD,Preq_serv/550,'g--')
plot(aPW,WSD,Preq_cc/550,'k--')
plot(aPW,WSD,Preq_man/550,'r-.')
legend(aPW,{'Cruise','Ceiling_{Service}','Ceiling_{Cruise}','2.5g @ SL'})
aPW.YLim=[0 ymabs(2)];

%% Optimum Output
plot(aPW,posout(1),posout(2),...
    'LineStyle','none',...
    'Marker','d',...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','y')