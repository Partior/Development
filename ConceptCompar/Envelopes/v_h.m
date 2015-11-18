%% Airspeed Versus Altiude
% Expansion on cr_speed.m for envelope use

clear; clc
load('../constants.mat')
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
g=@(h) 9.80665*(6371/(6371+h/3280.84))^2*3.2808399; % gravity at altitude in fps^2

sP=@(h,v,n) (Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*Cd0+K*n.^2*W0(19)^2./(0.5*v.*p(h)*S)))/W0(19);
nsolv=@(h,v) sqrt((Pa*sqrt(p(h)/p(0))-0.5*v.^3.*p(h)*S*Cd0)./...
    (K*W0(19)^2./(0.5*v.*p(h)*S)));


%% Domains:
% Altitude
hres=100;   % resolution
hdom=linspace(0,45e3,hres);
% Velocity, mach number
mres=100;   % resolution
mdom=linspace(0,0.5,mres);
% Mesh setup
[m_msh,h_msh]=meshgrid(mdom,hdom);

%% Mesh Calculations
plvl=vh_det(hdom,mdom.*a(hdom));
navail=nsolv(h_msh,m_msh.*a(h_msh));

%% Boundaries
% Top speed limited by drag on wings:
D_max=10000; % lbs_force

% Service Ceiling
sP=@(h,v,n) (Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*Cd0+K*n.^2*W0(19)^2./(0.5*v.*p(h)*S)))/W0(19);
V_mp=@(h) (K*W0(19)^2./(3/4*Cd0*p(h).^2*S^2)).^(1/4);
exP=@(h,v,n,pl) (pl*Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*Cd0+K*n.^2*W0(19)^2./(0.5*v.*p(h)*S)));
h_sc=fsolve(@(h) sP(h,V_mp(h),1),40e3,optimoptions('fsolve','Display','off'));

% Max Structural Drag
beta=@(m) sqrt(1-m^2);
hdom2=[hdom(hdom<h_sc),h_sc];
for itr=1:length(hdom2)
    hi=hdom2(itr);
    V_max(itr)=fsolve(@(v) D_max-1/2*p(hi)*v^2*S*2*Cd0*beta(v/a(hi)),...
        150,optimoptions('fsolve','Display','off'));  % V_md, at 2*Cd0
end
% Max Level Speed
for itr=1:length(hdom2)
    hi=hdom2(itr);
    V_max2(itr)=fsolve(@(v) exP(hi,v,1,1),400,...
        optimoptions('fsolve','Display','off'));
end

% Stall Speed
CLmax=1.6;
v_stall=sqrt(W0(19)./(1/2*p([hdom(hdom<h_sc),h_sc])*S*CLmax));

%% Plotting
figure(1); clf; hold on
[~,h2]=contour(m_msh,h_msh/1e3,real(navail),[0.5 0.75 1 1.25 1.5 1.75 2 2.25]);
set(h2,'LineColor','m','LineStyle','--',...
    'LineWidth',1,...
    'ShowText','on','LabelSpacing',572);

plll=[0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.25 1.5 1.75];
[~,h]=contour(m_msh,h_msh/1e3,plvl,plll);
set(h,'LineColor','k','LineStyle','-',...
    'LineWidth',1.5,...
    'ShowText','on','LabelSpacing',500);

xl=xlim;
yl=ylim;

plot(v_stall./a(hdom2),hdom2/1e3,'r-','LineWidth',1.4)
plot([v_stall(end),V_max2(end)]./([1 1]*a(h_sc)),[1 1]*h_sc/1e3,'r-','LineWidth',1.4)
plot(V_max2./a(hdom2),hdom2/1e3,'r-','LineWidth',1.4)

%% Pretty
xlabel('Mach'); ylabel('Altitude, 1,000 ft')
title('V-H Envelope, Power Settings, \color{magenta}Max G Manuevers \color{black}and \color{red}Level Flight Envelope')
xlim(xl)
ylim(yl)
