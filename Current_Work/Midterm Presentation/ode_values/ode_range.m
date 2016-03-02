%% Iterate through Ode's to determine true Range of Aircraft useing all stores of fuel
% no inputs
% outputs true range
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash

[t,fl]=ode45(@iterr,[0 2.5e4],Wf,...
    odeset('Events',@events_empty_fuel,'RelTol',1e-6),...
    {L,T,D,SFC_eq,W0,Wf});
    
r=t(end)*250*1.4666/5280;

fprintf('\n\n\t After %.2f hours, we traveled: \n\t %.0f miles \n\n\t with %.1f lbs of leftover fuel\n',...
    t(end)/3600,r,fl(end))
