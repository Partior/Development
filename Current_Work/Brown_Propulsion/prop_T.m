radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% Given:
%   airspeed velocity: ft/sec
%   altitude: feet
%   Number of props active 
% output Provided thrust by combined system
T=@(V,h,~,on)  ...
    [2,(on-2)]*...
    [Cr_T(V,h,oprpm_CR(V,h));
    Tk_T(V,h,oprpm_TK(V,h),oppit_TK(V,h))];   % MAX THRUST
