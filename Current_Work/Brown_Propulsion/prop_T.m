radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% Mach conisderations and imperical assumptions
% mach 0.85
m_effect=@(m) 1-(-atan((m-1.2)*6)+atan(-6*1.2))/(2*atan(-6*1.2));
% 
% The Mach Effects are now coverd in the thrust_curve for the indiviudual
% props as output by Brown. 26 FEB 2016

altitude_effects;   %provided by Hrovat

% final thrust equation 
T=@(V,h,P,on)  ...
    [2,(on-2)]*...
    [pT{1}(V,P/2*(1-1/8*(on-2)));pT{2}(V,P/8)*(on-2)]*...
    alt_effect(h);
% total thrust provided by entire DEP system with supplied power, in lb-ft