Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

vdom=linspace(0,0.7,300)*a(0);

P_i=Pa/n;
T_i=P_i./vdom;

rpm=3500; % max rpm rating
Mt=@(v,h,r) sqrt((v/(a(h)))^2+((rpm*2*pi/60)*r/a(h))^2);
Rmax=fsolve(@(r) 0.85-Mt(0.3*a(0),24e3,r),2.5,...
    optimoptions('fsolve','display','off'));
A=Rmax^2*pi;

T0=P_i^(2/3)*(2*p(0)*A)^(1/3);  % imperical forumula for static thrust
ind2=find(T_i/T0>0.8,1,'last'); % find where t/t0 =0.8
% develp a spline from static thrust to the power curve
yt=spline(vdom([1,ind2,ind2+1]),[T0 T_i([ind2,ind2+1])],vdom(1:ind2));
T_r=[yt,T_i(ind2+1:end)];   % combine static, spline and power curve
pT=griddedInterpolant(vdom,T_r,'linear');

% Mach conisderations and imperical assumptions
% Create an assumption that decreases thrust as tip approaches and surpass
% mach 0.85
m_effect=@(m) 1-(-atan((m-1.2)*4)+atan(-4*1.2))/(2*atan(-4*1.2));

alt_effect=@(h) 1.132*p(h)/p(0)-0.132; %http://www.dept.aoe.vt.edu/~lutze/AOE3104/thrustmodels.pdf
alt_effect=@(h) sqrt(p(h)/p(0)); % but I like this better
% final thrust equation
T=@(V,h) n*pT(V)*...
    m_effect(Mt(V,h,Rmax))/m_effect(Mt(0,0,Rmax))*...
    alt_effect(h);   %set af equal to 0 to negate altitue effects

clearvars P_i T_i rpm ind2 yt T_r pT T0 pp