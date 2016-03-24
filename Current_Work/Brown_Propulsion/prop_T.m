radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% Given:
%   airspeed velocity: ft/sec
%   altitude: feet
%   Number of props active
% output Provided thrust by combined system
T=@(V,h,~,on)  ...
    [2,(on-2)]*...
    [Cr_T(V,h,opmt_rpm_pow(V,h,package,1));
    Tk_T(V,h,opmt_rpm_pow(V,h,package,2))];
% assuming turning at best possible rpm, with rpm_max at 2500
