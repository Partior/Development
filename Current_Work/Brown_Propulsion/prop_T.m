radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

%%
% Given:
%   airspeed velocity: ft/sec
%   altitude: feet
%   Number of props active 

% TAKEOFF THRUST
T=@(V,h,on)  ...
    [2,(on-2)]*...
    [Cr_T(V,h,opmt_rpm_pow(V,h,{Cr_P;Tk_P},1,100));
    Tk_T(V,h,oprpm_TK(V,0))];

% CRUISE THRUST
Tc=@(V,h) ...
    2*Cr_T(V,h,opmt_rpm_pow(V,h,{Cr_P;Tk_P},1,340));

