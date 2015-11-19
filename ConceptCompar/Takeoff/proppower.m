function tcmp_t=proppower(n,Pa,varargin)
%% POWER
% Detailed look into power proudced by props

if nargin<3
    gph=true;
else
    gph=varargin{1};
end

Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
beta=@(m) sqrt(1-m.^2);

vdom=linspace(0,0.7,300)*a(0);

P_i=Pa/n;
T_i=P_i./vdom;

rpm=3000; % max rpm rating
Rmax=sqrt((a(0)*0.85)^2-(270*1.466)^2)/(rpm*2*pi/60);
A=Rmax^2*pi; p=2.3e-3;

T0=P_i^(2/3)*(2*p*A)^(1/3);
ind2=find(T_i/T0>0.8,1,'last');
yt=spline(vdom([1,ind2,ind2+1]),[T0 T_i([ind2,ind2+1])],vdom(1:ind2));
T_r=[yt,T_i(ind2+1:end)];
pT=griddedInterpolant(vdom,T_r,'linear');
T=@(V) n*pT(V);

Mr=@(h) Rmax*rpm*2*pi/60/a(h);
T_cmp=@(V,h) 3/2.*(((1+(V/a(h)).^2)/Mr(h)^3.*asin(Mr(h)./beta(V/a(h)))-...
    sqrt(1-Mr(h)^2-(V/a(h)).^2)/Mr(h)^2)./...
    (1+3*((V/a(h)).^2/Mr(h)^2)));
T_cmp_pl=T_cmp(vdom,0).*T(vdom)/(T0*n);
T_cmp_pl=T_cmp_pl(imag(T_cmp_pl)==0);

if gph
    figure(2); clf
    hold on; plot(vdom/a(0),T_i/T0,'--')
    plot(vdom/a(0),T(vdom)/(T0*n))
    plot(vdom(1:length(T_cmp_pl))/a(0),T_cmp_pl)
    ylim([0 1.4])
    grid on
    legend({'Ideal','Assumed','Compressibles'})
    title('Thrust Curve')
    ylabel('T/T_0')
    xlabel('Mach')
    tt=sprintf('Pa=%.0f hp, n=%g \nT_0=%0.f R_{max}=%0.2f ft',Pa/550,n,T(0),Rmax);
    text(0.3,0.8,tt)
end
end