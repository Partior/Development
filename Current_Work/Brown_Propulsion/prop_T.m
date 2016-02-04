radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% Mach conisderations and imperical assumptions
% mach 0.85
m_effect=@(m) 1-(-atan((m-1.2)*6)+atan(-6*1.2))/(2*atan(-6*1.2));

altitude_effects;   %provided by Hrovat

% final thrust equation
T=@(V,h,P) pT(V,P)*...
    m_effect(Mt(V,h,Rmax))*...
    alt_effect(h);