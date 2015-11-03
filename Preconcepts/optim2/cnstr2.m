function [wsx,py,WTO]=cnstr2(AR,V_c,p_c,posout,f_det,gph)
%% Constraint Analysis
%Designed to output information and plots for contraint Analysis

load('constants.mat')
%% Takeoff Weight Estimation
% This script will run to determine estimated Gross Takeoff Weight, results
% in assignment to Wto
Wto=@(w) west3(AR,V_c,p_c,w);
Wf_Wto=@(w) wfest(AR,V_c,p_c,w);

%% Ranges for W/S
WSdom=linspace(5,60,25);
ms=length(WSdom);

%% Limits on W/S
% Wing-loading minimum to meet required Range
WS_r=fsolve(@(x) Wf_Wto(x)*Wto(x)*1.07/SFC*(x/(p_c))^0.5*(AR*e).^(1/4)/cd0^(3/4)*(1/Wto(x))-R,...
    15,optimoptions('fsolve','Display','off'));
% Wing-loading min to meet C_L_max and V_stall assumptions
WS_s=0.5*p_c*V_stall^2*Cl_max;
% Limit on W/S for Landing Distance within required distance, 3 degree
% angle of approach
WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
    50,optimoptions('fsolve','display','off'));

%% Takeoff Distance
% W/S and T/W to takeoff at required distance
s_tm=zeros(1,ms);
VTO=V_stall*1.2;
% for itr=1:ms
    s_tm=@(ws) Wto(ws)*VTO/550*fsolve(@(tw) ...
        s_T-... The distance reguirement (3000ft by RFP)
        (20.9*(ws/(Cl_max*tw))+69.6*sqrt(ws/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
% end
% %% Takeoff Power, from Takeoff T/W
% VTO=V_stall*1.2;
% n=6; d=5;
% T0=@(p) 0.25*(p./n.*d).^(2/3);
% T0t=@(p) T0(p).*n;
% a=@(p) ((p/VTO)-T0t(p))/(VTO)^2;
% mu=0.04; % Firm Turf
% Cdg=0.0527; %Ground roll drag
% A=@(p,ws) 32.2*(T0t(p)/Wto(ws)-mu);
% B=@(p,ws) 32.2/Wto(ws)*(0.5*p_sl*(Wto(ws)/ws)*(Cdg-mu*Cl_max)+a(p));
% s=@(p,ws) 1./(2*B(p,ws)).*log(A(p,ws)./(A(p,ws)-B(p,ws)*(VTO)^2));
% Preq_TOop=@(ws) fsolve(@(p) s(p,ws)-2000,1000*550,optimoptions('fsolve','Display','off'));
% % for itr=1:ms
% %     Preq_TO(itr)=Preq_TOop(WSdom(itr))/550;
% % end


%% Cruise Conditions
% For both cruise and climb conditions, leaving off 1/g(dV/dt) term
TW_c=@(ws,p,V,n,hdot)...
    (0.5*p*V.^2)*cd0./ws+1./(e*pi*AR)*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);
PW=@(ws,p,v,n,hdot) ...
    TW_c(ws,p,v,n,hdot).*v/550.*Wto(ws)/sqrt(p/p_sl);
% For Straight, Level Flight at cruise conditions
TW_cruise=@(ws)...
    PW(ws,p_c,V_c,1,0);
% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=@(ws)...
    PW(ws,p_sc,V_mp(ws,p_sc,1./(e*pi*AR)),1,100/60);
% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=@(ws)...
    PW(ws,p_c,V_mp(ws,p_c,1./(e*pi*AR)),1,300/60);

%% Output
mat=[{TW_cruise};{TW_cc};{TW_serv};{s_tm}];
lm=[max(WS_r,WS_s),WS_l];
if lm(1)>lm(2)
    wsx=[];
    py=[];
    WTO=[];
    return
end
[wsx,py]=fminbnd(@(ws) ...
    max([mat{1}(ws),mat{2}(ws),mat{3}(ws),mat{4}(ws)]),...
    lm(1),lm(2));
WTO=Wto(wsx);
%% Graphic Output
if ~gph
    return  % return to caller if no request for gph
end
% Axis of WS and TW

figure(f_det);
aTW=gca;
cla(aTW)
plot(aTW,WSdom,s_tm(WSdom),'b-')       % Takeoff Distance Req
plot(aTW,WSdom,TW_cruise(WSdom),'b--') % Cruise Req
plot(aTW,WSdom,TW_serv(WSdom),'g--')   % Service Ceiling Req
plot(aTW,WSdom,TW_cc(WSdom),'k--')     % Cruise Ceiling Req
aTW.XLimMode='auto';
aTW.YLimMode='auto';
% aTW.YLimMode='manual';
% Min W/S Req for range and stall
% ym=[0 posout(2)*2];
% aTW.YLim=ym;
ym=aTW.YLim;
plot(aTW,WS_r*ones(1,2),ym,'k:')
plot(aTW,WS_s*ones(1,2),ym,'r:')
plot(aTW,WS_l*ones(1,2),ym,'b:')

%% Optimum Output
plot(aTW,posout(1),posout(2),...
    'LineStyle','none',...
    'Marker','d',...
    'MarkerSize',13,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','y')

%% Determine Design Space
% Select Conditions to include in Design Space, and Plot Dots
% Run dot maker
TWdom=linspace(ym(1),ym(2),ms);
[WSspace,TWspace]=meshgrid(WSdom,TWdom);
designspace=zeros(ms);
for ita=1:ms
    for itb=1:ms
        wsl=WSdom(itb);
        tstmat=[TWspace(ita,itb)>s_tm(wsl);
            TWspace(ita,itb)>TW_cruise(wsl);
            TWspace(ita,itb)>TW_serv(wsl);
            TWspace(ita,itb)>TW_cc(wsl);
            WSspace(ita,itb)>WS_r;
            WSspace(ita,itb)>WS_s;
            WSspace(ita,itb)<WS_l;];
        designspace(ita,itb)=all(tstmat);
    end
end
plot(WSspace(designspace==1),TWspace(designspace==1),'c.')

%% Visual Adjustments
%Legend
legend(aTW,{'Takeoff',...
    'Cruise','Ceiling_{service}','Ceiling_{cruise}',...
    'Range','Stall','Landing'},...
    'Location','north')

% Text Output
title(aTW,sprintf('Constriants: AR=%0.2g,Vc=%0.3g,pc=%0.3e',AR,Vc,pc)) 
xm=xlim;
axes(aTW)
wf=Wf_Wto(wsx)*Wto(wsx); we=Wto(wsx)-Wfix-wf;
text(0.98*xm(2),0.05*ym(2),sprintf(...
    '%8s = %6.0flbs\n%8s = %6.0flbs\n%8s = %6.0flbs',...
    'W_{emp}',we,'W_{fuel}',wf,'W_{TO}',Wto(wsx)),...
    'horizontalAlignment','right','verticalAlignment','bottom','Parent',aTW)
text(WS_r,0.95*ym(2),sprintf('%0.0f nm',R/1.151),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_s,0.90*ym(2),sprintf('%0.0f KTAS',V_stall/1.688),...
    'horizontalAlignment','left','verticalAlignment','top')
text(WS_l,0.95*ym(2),sprintf('%0.0f ft',s_T),...
    'horizontalAlignment','right','verticalAlignment','top')
ylim(ym)