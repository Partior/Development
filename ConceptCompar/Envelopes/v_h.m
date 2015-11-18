%% Airspeed Versus Altiude
% Expansion on cr_speed.m for envelope use

clear; clc
load('../constants.mat')
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
beta=@(m) sqrt(1-m.^2);
g=@(h) 9.80665*(6371/(6371+h/3280.84))^2*3.2808399; % gravity at altitude in fps^2

cd=@(v,h) Cd0./beta(v./a(h));
sP=@(h,v,n) (Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*cd(v,h)+K*n.^2*W0(19)^2./(0.5*v.*p(h)*S)))/W0(19);
nsolv=@(h,v) sqrt((Pa*sqrt(p(h)/p(0))-0.5*v.^3.*p(h)*S.*cd(v,h))./...
    (K*W0(19)^2./(0.5*v.*p(h)*S)));


%% Domains:
% Altitude
hres=100;   % resolution
hdom=linspace(0,45e3,hres);
% Velocity, mach number
mres=100;   % resolution
mdom=linspace(0,0.6,mres);
% Mesh setup
[m_msh,h_msh]=meshgrid(mdom,hdom);

%% Mesh Calculations
plvl=(0.5*(m_msh.*a(h_msh)).^3.*p(h_msh)*S.*cd(m_msh.*a(h_msh),h_msh)+K*W0(19)^2./(0.5*(m_msh.*a(h_msh)).*p(h_msh)*S))./(Pa*sqrt(p(h_msh)/p(0)));
navail=nsolv(h_msh,m_msh.*a(h_msh));

%% Boundaries: Stall Speed
CLmax=1.6;
hinter=fsolve(@(h) sP(h,sqrt(W0(19)./(1/2*p(h)*S*CLmax)),1),40e3,optimoptions('fsolve','Display','off'));
hdom3=[hdom(hdom<hinter),hinter];
v_stall=sqrt(W0(19)./(1/2*p(hdom3)*S*CLmax));
% Service Ceiling
V_mp=@(h) (K*W0(19)^2./(3/4*Cd0*p(h).^2*S^2)).^(1/4);                            
h_sc=fsolve(@(h) sP(h,V_mp(h),1)-100/60,40e3,optimoptions('fsolve','Display','off')); 

%% Plotting
figure(1); clf; hold on
[~,h2_m]=contour(m_msh,h_msh/1e3,real(navail),[0.5 1.5 2]);
set(h2_m,'LineColor','r','LineStyle','--',...
    'LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
[~,h2_s]=contour(m_msh,h_msh/1e3,real(navail),[0.75 1.25 1.75 2.25]);
set(h2_s,'LineColor','r','LineStyle',':',...
    'LineWidth',0.5);

[~,h_m]=contour(m_msh,h_msh/1e3,plvl,[0.5 0.75 1 1.5]);
set(h_m,'LineColor','k','LineStyle','-',...
    'LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
[~,h_s]=contour(m_msh,h_msh/1e3,plvl,[0.3 0.4 0.6 0.7 0.8 0.9 1.1 1.2 1.3 1.4]);
set(h_s,'LineColor','k','LineStyle',':',...
    'LineWidth',0.1);

xl=xlim;
yl=ylim;

plot(v_stall./a(hdom3),hdom3/1e3,'b-','LineWidth',1.4)
plot(mdom([1,end]),h_sc*[1,1]/1e3,'m:')

%% Pretty
xlabel('Mach'); ylabel('Altitude, 1,000 ft')
title({'V-H Envelope';...
    'Power Settings, \color{red}Max G Manuevers \color{black}, \color{blue}Level Flight Stall \color{black}and \color{magenta}Service Ceiling'})
xlim(xl)
ylim(yl)
