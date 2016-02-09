%% Thrust Curve;
% Thrust of Propellers at given free stream velocity

vdom=linspace(0,0.7,300)*a(0);
Padom=linspace(50,800,30)*550;
for itPa=1:30
    Pi=Padom(itPa);
    T_i=Pi./vdom;
    T0=Pi^(2/3)*(2*p(0)*A)^(1/3);  % imperical forumula for static thrust
    ind2=find(T_i/T0>0.8,1,'last'); % find where t/t0 =0.8
    % develp a spline from static thrust to the power curve
    yt=spline(vdom([1,ind2,ind2+1]),[T0 T_i([ind2,ind2+1])],vdom(1:ind2));
    T_r(:,itPa)=[yt,T_i(ind2+1:end)];   % combine static, spline and power curve
end
[vm,pm]=ndgrid(vdom,Padom);
pT=griddedInterpolant({vdom,Padom},T_r,'linear','none');