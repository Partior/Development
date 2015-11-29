%% Airspeed Versus Altiude
% Expansion on cr_speed.m for envelope use

clear; clc
load('../constants.mat')
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
beta=@(m) sqrt(1-m.^2); % Praudnlt-gluaert trransformation
g=@(h) 9.80665*(6371/(6371+h/3280.84))^2*3.2808399; % gravity at altitude in fps^2

cd=@(v,h) Cd0./beta(v./a(h));   % cd transformed
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
% for power levels, power reduired devided by power avalibe
plvl=(0.5*(m_msh.*a(h_msh)).^3.*p(h_msh)*S.*cd(m_msh.*a(h_msh),h_msh)+K*W0(19)^2./(0.5*(m_msh.*a(h_msh)).*p(h_msh)*S))./(Pa*sqrt(p(h_msh)/p(0)));
navail=nsolv(h_msh,m_msh.*a(h_msh)); % highest leve of n-manuever avalibe at full power

%% Boundaries: Stall Speed
CLmax=1.6;   % conservativie assumption
hinter=fsolve(@(h) sP(h,sqrt(W0(19)./(1/2*p(h)*S*CLmax)),1),40e3,optimoptions('fsolve','Display','off'));
hdom3=[hdom(hdom<hinter),hinter];   % max altitude at v_stall (meets full power line)
v_stall=sqrt(W0(19)./(1/2*p(hdom3)*S*CLmax));
% Service Ceiling
V_mp=@(h) (K*W0(19)^2./(3/4*Cd0*p(h).^2*S^2)).^(1/4);                            
h_sc=fsolve(@(h) sP(h,V_mp(h),1)-100/60,40e3,optimoptions('fsolve','Display','off')); 

%% Plotting
figure(1); clf; hold on

% Not doing the '1' for the contour line as it matches the power levels
% gmdom=0.75:0.25:2.25;
% gmint=[0.5 1.5 2];
% for itr=1:length(gmdom)
%     if any(abs(gmdom(itr)-gmint)<1e-8)
%         gmdom(itr)=0;
%     end
% end
% gmdom=nonzeros(gmdom);
% [~,h2_m]=contour(m_msh,h_msh/1e3,real(navail),gmint);
% set(h2_m,'LineColor','r','LineStyle','-','LineWidth',1.5,...
%     'LineWidth',1.5,...
%     'ShowText','on','LabelSpacing',400);
% [~,h2_s]=contour(m_msh,h_msh/1e3,real(navail),gmdom);
% set(h2_s,'LineColor','r','LineStyle',':','LineWidth',1,...
%     'LineWidth',0.5);

gmdom=0.3:0.1:1.4;
gmint=[0.5 0.75 1 1.5];
for itr=1:length(gmdom)
    if any(abs(gmdom(itr)-gmint)<1e-8)
        gmdom(itr)=0;
    end
end
[~,h_m]=contour(m_msh,h_msh/1e3,plvl,gmint);
set(h_m,'LineColor','k','LineStyle','-','LineWidth',1.5,...
    'LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
[~,h_s]=contour(m_msh,h_msh/1e3,plvl,gmdom);
set(h_s,'LineColor','k','LineStyle',':','LineWidth',1,...
    'LineWidth',0.1);

xl=xlim;
yl=ylim;

plot(v_stall./a(hdom3),hdom3/1e3,'b-','LineWidth',1.4)
plot(mdom([1,end]),h_sc*[1,1]/1e3,'m--')

%% Pretty
xlabel('Mach'); ylabel('Altitude, 1,000 ft')
title({'V-H Envelope';...
    'Power Settings, \color{red}Max G Manuevers \color{black}, \color{blue}Level Flight Stall \color{black}and \color{magenta}Service Ceiling'})
xlim(xl)
ylim(yl)
