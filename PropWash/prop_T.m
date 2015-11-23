Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

vdom=linspace(0,0.7,300)*a(0);

P_i=Pa/n;
T_i=P_i./vdom;

rpm=3500; % max rpm rating
Rmax=sqrt((a(0)*0.85)^2-(300*1.466)^2)/(rpm*2*pi/60);
A=Rmax^2*pi;

T0=P_i^(2/3)*(2*p(0)*A)^(1/3);
ind2=find(T_i/T0>0.8,1,'last');
yt=spline(vdom([1,ind2,ind2+1]),[T0 T_i([ind2,ind2+1])],vdom(1:ind2));
T_r=[yt,T_i(ind2+1:end)];
pT=griddedInterpolant(vdom,T_r,'linear');
T=@(V) n*pT(V);

clearvars P_i T_i rpm ind2 yt T_r pT T0