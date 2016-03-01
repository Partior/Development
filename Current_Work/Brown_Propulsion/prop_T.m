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
    [Cr_T(V,h,opmt_rpm_pow(V,h,package,1)); Tk_T(V,h,opmt_rpm_pow(V,h,package,2))];
% assuming turning at best possible rpm, with rpm_max at 3500

P_Prop=@(V,h,~,on)  ...
    [2,(on-2)]*...
    [n_Pc(j_ratio(V,opmt_rpm_pow(V,h,package,1),Rmax(1)))/100*...
         Cr_P(V,h,opmt_rpm_pow(V,h,package,1))/550;...
     n_Pt(j_ratio(V,opmt_rpm_pow(V,h,package,2),Rmax(2)))/100*...
         Tk_P(V,h,opmt_rpm_pow(V,h,package,2))/550];
