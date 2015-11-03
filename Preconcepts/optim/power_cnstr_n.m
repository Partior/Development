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

D=@(ws,V,p,dhdt,n) (Wto*dhdt)./V + (Cd0*V.^2*Wto*p)./(2*ws) + (2*K*Wto*n^2.*ws)./(V.^2*p);
Pr=@(ws,V,p,dhdt,n) (K*V*Wto.*ws*n^2)./(0.5*p.*V.^2) + dhdt*Wto + Cd0*Wto./ws.*V.*(0.5*p.*V.^2);

% Straight, Level Flight
Preq_cruise=D(WSD,V_c,p_c,0,1)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSD,V_mp(WSD,p_sc),p_sc,100/60,1).*V_mp(WSD,p_sc)/(p_sc/p_sl));
% Cruise Ceiling
Preq_cc=D(WSD,V_mp(WSD,p_c),p_c,300/60,1).*V_mp(WSD,p_c)/(p_c/p_sl);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSD,V_c,p_sl,0,2.5)*V_c/(p_sl/p_sl);
% Takeoff Power required (T/W * Wto * V_To)
% Takeoff Power, from Takeoff T/W
            VTO=V_stall*1.2;
            n=6; d=5;
            T0=@(p) 0.25*(p./n.*d).^(2/3);
            T0t=@(p) T0(p).*n;
            mu=0.04; % Firm Turf
            Cdg=0.0527; %Ground roll drag
            CLg=1.7; % max ground lift
            a=@(p) ((p/VTO)-T0t(p))/(VTO)^2;
            A=@(p) 32.2*(T0t(p)/Wto-mu);
            B=@(p,ws) 32.2/Wto*(0.5*p_sl*(Wto./ws)*(Cdg-mu*CLg)+a(p));
            s=@(p,ws) 1./(2*B(p,ws)).*log(A(p)./(A(p)-B(p,ws)*(VTO)^2));
            Preq_TO=@(ws) fsolve(@(p) s(p,ws)-1500,1e5,optimoptions('fsolve','Display','off'));
% Preq_cruise=Pr(WSD,V_c,p_c,0,1)/(p_c/p_sl);
% Preq_serv=Pr(WSD,V_mp(WSD,p_sc),p_sc,100/60,1)/(p_sc/p_sl);
% Preq_cc=Pr(WSD,V_mp(WSD,p_c),p_c,300/60,1)/(p_c/p_sl);
% Preq_man=Pr(WSD,V_c,p_sl,0,2.5)/(p_sl/p_sl);


%% Graphic Output
% figure(f_det);
% axes(aPW);
cla(aPW)
aPW.XLimMode='auto';
aPW.YLimMode='auto';
plot(aPW,WSD,Preq_cruise/550,'b--')
plot(aPW,WSD,Preq_serv/550,'g--')
plot(aPW,WSD,Preq_cc/550,'k--')
plot(aPW,WSD,Preq_man/550,'r-.')
for itr=1:length(WSD)
    Preq_TOe(itr)=Preq_TO(WSD(itr))/550;
end
plot(aPW,WSD,Preq_TOe,'b-')
% if aPW.YLim(2)>ymabs(2)
%     aPW.YLim=[0 1.2*ymabs(2)];
% end

% %% Optimum Output
% plot(aPW,posout(1),posout(2),...
%     'LineStyle','none',...
%     'Marker','d',...
%     'MarkerSize',10,...
%     'MarkerEdgeColor','r',...
%     'MarkerFaceColor','y')