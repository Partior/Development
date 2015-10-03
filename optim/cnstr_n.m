%% Constraint Analysis _ Numerical
% Modification of constr.m for the purposes of numeric output only.

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
s_tm=zeros(1,WSl);
for a=1:WSl
    s_tm(a)=fsolve(@(tw) ...
        s_T-(20.9*(WSdom(a)/(Cl_max*tw))+69.6*sqrt(WSdom(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end

%% Cruise Conditions

% For Straight, Level Flight at cruise conditions
TW_cruise=TW_c(WSdom,p_c,V_c,1,0);

% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=TW_c(WSdom,p_sc,V_md(WSdom,p_sc),1,100/60);

% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=TW_c(WSdom,p_c,V_md(WSdom,p_c),1,300/60);

% Maneuver at Sea Level, cruise conditions, 2.5 g's
TW_man=TW_c(WSdom,p_sl,V_c,2.5,0);