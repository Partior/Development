%% Constraint Analysis
%Designed to output information and plots for contraint Analysis for use to
%develop a design space for Partior Q==1. 

% Alex M Granata
% 01 OCT 2015
clear; clc

% Ask what values they actually care about
vales=designspacedeterminant;
vales=cell2mat(vales);
%% Assumptions about Aircraft Parameters
% This script addes asumption variables to the workspace
assumer

%% Takeoff Weight Estimation
% This script will run to determine estimated Gross Takeoff Weight, results
% in assignment to Wto
W_est

%% Ranges for W/S 
WSdom=linspace(5,60,25);
ms=length(WSdom);

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
s_tm=zeros(1,ms);
for a=1:ms
    s_tm(a)=fsolve(@(tw) ...
        s_T-(20.9*(WSdom(a)/(Cl_max*tw))+69.6*sqrt(WSdom(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end


%% Cruise Conditions
% For both cruise and climb conditions, leaving off 1/g(dV/dt) term
TW_c=@(ws,p,V,n,hdot)...
    (0.5*p*V.^2)*Cd0./ws+K*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);

% For Straight, Level Flight at cruise conditions
TW_cruise=TW_c(WSdom,p_c,V_c,1,0);

% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=TW_c(WSdom,p_sc,V_md(WSdom,p_sc),1,100/60);

% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=TW_c(WSdom,p_c,V_md(WSdom,p_c),1,300/60);

% Maneuver at Sea Level, cruise conditions, 2.5 g's
TW_man=TW_c(WSdom,p_sl,V_c,2.5,0);

%% Graphic Output
% Axis of WS and TW

f1=figure(1); clf
hold on
if vales(1)
    plot(WSdom,s_tm,'b-')       % Takeoff Distance Req
end
if vales(2)
    plot(WSdom,TW_cruise,'b--') % Cruise Req
end
if vales(3)
    plot(WSdom,TW_serv,'g--')   % Service Ceiling Req
end
if vales(4)
    plot(WSdom,TW_cc,'k--')     % Cruise Ceiling Req
end
if vales(5)
    plot(WSdom,TW_man,'r-.')    % Maneuver Req
end


% Min W/S Req for range and stall
ym=ylim;
if vales(6)
    plot(WS_r*ones(1,2),ym,'k:')
end
if vales(7)
    plot(WS_s*ones(1,2),ym,'r:')
end
if vales(8)
    plot(WS_l*ones(1,2),ym,'b:')
end
                
%% Determine Design Space
% Select Conditions to include in Design Space, and Plot Dots
% Run dot maker
TWdom=linspace(ym(1),ym(2),ms);
[WSspace,TWspace]=meshgrid(WSdom,TWdom);
designspace=zeros(ms);
for a=1:ms
    for b=1:ms
        tstmat=[TWspace(a,b)>s_tm(b);
            TWspace(a,b)>TW_cruise(b);
            TWspace(a,b)>TW_serv(b);
            TWspace(a,b)>TW_cc(b);
            TWspace(a,b)>TW_man(b);
            WSspace(a,b)>WS_r;
            WSspace(a,b)>WS_s;
            WSspace(a,b)<WS_l;];
        designspace(a,b)=all((tstmat==vales) | tstmat);
    end
end
plot(WSspace(designspace==1),TWspace(designspace==1),'c.')

%% Visual Adjustments
% Size Matters
lgndstr={'Takeoff',...
    'Cruise','Ceiling_{service}','Ceiling_{cruise}','2.5g @ SL',...
    'Range','Stall','Landing'};
legend(lgndstr(vales==1),...
    'Location','north')
set(gcf,...
    'WindowStyle','normal',...
    'Units','inches',...
    'Name','Graphic Output',...
    'DockControls','off',...
    'SizeChangedFcn',@lgnd)
lgnd(f1)

%% Axis, Title and Text
xlabel('Wing Loading, lbs/ft^2')
ylabel('Thrust to Weight Ratio, lbf/lbm')
title('Partior Q==1: Design Space')
% Text Output
xm=xlim;
text(0.98*xm(2),0.1*ym(2),sprintf('W_{TO}=%6.0f lbs',Wto),...
    'horizontalAlignment','right','verticalAlignment','bottom')
if vales(6)
text(WS_r,0.95*ym(2),sprintf('%0.0f nm',R/1.151),...
    'horizontalAlignment','left','verticalAlignment','top')
end
if vales(7)
text(WS_s,0.90*ym(2),sprintf('%0.0f KTAS',V_stall/1.688),...
    'horizontalAlignment','left','verticalAlignment','top')
end
if vales(8)
text(WS_l,0.95*ym(2),sprintf('%0.0f ft',s_T),...
    'horizontalAlignment','right','verticalAlignment','top')
end
ylim(ym)

