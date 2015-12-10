Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

vdom=linspace(0,0.7,300)*a(0);

rpm=2500; % max rpm rating
Mt=@(v,h,r) sqrt((v/(a(h)))^2+((rpm*2*pi/60)*r/a(h))^2);
Rmax=fsolve(@(r) 0.85-Mt(366,25e3,r),2,optimoptions('fsolve','display','off'));
b=sqrt(AR*S);
Rmax=min(Rmax,(b-9)/(2*n)); % 9 feet cabin diameter
A=Rmax^2*pi;

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

% Mach conisderations and imperical assumptions
% Create an assumption that decreases thrust as tip approaches and surpass
% mach 0.85
m_effect=@(m) 1-(-atan((m-1.2)*6)+atan(-6*1.2))/(2*atan(-6*1.2));

alt_effect=@(h) 1.132*p(h)/p(0)-0.132; %http://www.dept.aoe.vt.edu/~lutze/AOE3104/thrustmodels.pdf
% Using instead turbo charger function, from line C of graph on 
% http://rwebs.net/avhistory/opsman/geturbo/geturbo.htm
alt_effect=@(h) min([0.90;1.132*p(h)/p(10e3)-0.132]);

% final thrust equation
T=@(V,h,P) pT(V,P)*...
    m_effect(Mt(V,h,Rmax))*...
    alt_effect(h);

clearvars P_i T_i rpm ind2 yt T_r pT T0 pp