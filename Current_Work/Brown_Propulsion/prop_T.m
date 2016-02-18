radius_prop;    % provided by Brown 

thrust_curve;   %provided by Brown

% Mach conisderations and imperical assumptions
% mach 0.85
m_effect=@(m) 1-(-atan((m-1.2)*6)+atan(-6*1.2))/(2*atan(-6*1.2));

altitude_effects;   %provided by Hrovat

% final thrust equation
% T=@(V,h,P,on)  (pT{1}(V,P/2*(1-1/8*on))*2*m_effect(Mt(V,h,Rmax(1)))+...
%             pT{2}(V,P/8)*on*m_effect(Mt(V,h,Rmax(2))))*...
%             alt_effect(h);
%         
T=@(V,h,P,on)  ...
    (pT{1}(V,P/2*(1-1/8*(on-2)))*2*m_effect(Mt(V,h,Rmax(1)))+...
    pT{2}(V,P/8)*(on-2)*m_effect(Mt(V,h,Rmax(2))))*...
    alt_effect(h);