function T=proppower(n,Pa,varargin)
%% POWER 
% Detailed look into power proudced by props

if nargin<3
    gph=true;
else
    gph=varargin{1};
end

a=1125.33;
vdom=linspace(0,a*0.5,300);

P_i=Pa/n;
T_i=P_i./vdom;

rpm=4000; % max rpm rating
Rmax=sqrt((a*1)^2-(200*1.466)^2)/(rpm*2*pi/60);
A=Rmax^2*pi; p=2.3e-3;

T0=P_i^(2/3)*(2*p*A)^(1/3);
ind2=find(T_i/T0>0.75,1,'last');
ind1=find(vdom<0.4*vdom(ind2),1,'last');
yt=spline(vdom([ind1-1,ind1,ind2,ind2+1]),[T0 T0 T_i([ind2,ind2+1])],vdom(ind1:ind2));
T_r=[T0*ones(1,ind1-1),yt,T_i(ind2+1:end)];
pT=griddedInterpolant(vdom,T_r,'linear');
T=@(V) n*pT(V);

if gph
    figure(2); clf
    hold on; plot(vdom/a,T_i/T0,'--')
    plot(vdom/a,T(vdom)/(T0*n))
    ylim([0 1.25])
    grid on
    legend({'Ideal','Assumed'})
    title('Thrust Curve')
    ylabel('T/T_0')
    xlabel('Mach')
    tt=sprintf('Pa=%.0f hp, n=%g \nT_0=%0.f R_{max}=%0.2f ft',Pa/550,n,T(0),Rmax);
    text(0.3,0.8,tt)
end