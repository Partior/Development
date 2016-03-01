radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% % Mach conisderations and imperical assumptions
% % mach 0.85
% m_effect=@(m) 1-(-atan((m-1.2)*6)+atan(-6*1.2))/(2*atan(-6*1.2));
% % 
% The Mach Effects are now coverd in the thrust_curve for the indiviudual
% props as output by Brown. 26 FEB 2016

% altitude_effects;   %provided by Hrovat
% % outputs alt_effect(h)

% Given:
%   airspeed velocity: ft/sec
%   altitude: feet
%   Shaft Horse Power, i.e. not including motor or ASU inefficiencies
%   Number of props active
% output Provided thrust by combined system
T=@(V,h,~,on)  ...
    [2,(on-2)]*...
    [max(Cr_T(V,h,opmt_rpm(V,package,1)),0); max(Tk_T(V,h,opmt_rpm(V,package,2)),0)];
% assuming turning at best possible rpm, with rpm_max at 3500

P_Prop=@(V,h,P,on)  ...
    [2*(P/2*(1-(on-2)/8)),(on-2)*P/8]*...
    [max(SHP_C(V,h,opmt_rpm(V,package,1)),0);max(SHP_T(V,h,opmt_rpm(V,package,2)),0)];
