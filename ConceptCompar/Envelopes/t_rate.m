%% Turn Rate at Altitude and Mach Speeds

clear; clc

load('../constants.mat')
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

g=@(h) 9.80665*(6371/(6371+h/3280.84))^2*3.2808399; % gravity at altitude in fps^2

gturn=@(h,v,om) sqrt(g(h)^2+(v.*om).^2)/g(h);  % n's for a turn, v in fps, h in ft, om in rad/sec

sP=@(h,v,n) (Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3*p(h)*S*Cd0+K*n.^2*W0(19)^2./(0.5*v*p(h)*S)))/W0(19);
%% Variable Domains

% Turn Rates
omres=97;   % resolution
omdom=linspace(0,24*pi/180,omres);  % from 0 deg/sec to a four rate turn (12 degress/sec)
% Velocity, mach number
mres=151;   % resolution
mdom=linspace(0,0.75,mres);

% Mesh setup
[m_msh,om_msh]=meshgrid(mdom,omdom);

%% Local Limits
% Top speed limited by drag on wings:
D_max=10000; % lbs_force

%% Mesh Calculations
hi=0;   % Altitude of Interest
nreq=gturn(hi,m_msh*a(hi),om_msh);
sPreq=sP(hi,m_msh*a(hi),nreq);

%% Graphing
figure(1); clf; hold on
% Specific power
[~,h_s]=contour(m_msh,om_msh*180/pi,sPreq,linspace(-20,20,9));
set(h_s,'LineColor','k','LineStyle',':');
[~,h_m]=contour(m_msh,om_msh*180/pi,sPreq,[0 10 20]);
set(h_m,'LineColor','k','LineStyle','-',...
    'ShowText','on','LabelSpacing',500);    
% G's
[~,h2_s]=contour(m_msh,om_msh*180/pi,nreq,[1.1 1.5 2.5 3.5]);
set(h2_s,'LineColor','b','LineStyle',':');
[~,h2_m]=contour(m_msh,om_msh*180/pi,nreq,[2 3 4]);
set(h2_m,'LineColor','b','LineStyle','-.',...
    'ShowText','on','LabelSpacing',500);

%% Boundaries
% Max Structural Drag
V_max=sqrt(D_max/((2*Cd0)*1/2*p(hi)*S));  % V_md, at 2*Cd0
V_max_trate=fsolve(@(w) gturn(hi,V_max,w)-3.8,15,...
    optimoptions('fsolve','Display','none'))*180/pi;

% Stalling Speed
V_stall=80*1.466;
CLmax=1.6;
om_max=[];
    % the below for loop does the following:
%     assign tmp to min velocity to maintain level turn (v_stall)
%     iterate to either turn > 3.8 or vel_stall > v_max
%     depending on above conditions, assign end values to meet up to the
%     two other lines to make a pretty connections
for itr=1:omres
    tmp=fsolve(@(v)  W0(19)*gturn(hi,v,omdom(itr))-(1/2*p(hi)*v^2*S*CLmax),120,...
        optimoptions('fsolve','Display','none'));
    if gturn(hi,tmp,omdom(itr))>3.8
        V_stall_trate(itr)=fsolve(@(v)  W0(19)*3.8-(1/2*p(hi)*v^2*S*CLmax),120,...
            optimoptions('fsolve','Display','none'));
        om_max=fsolve(@(w) gturn(hi,V_stall_trate(itr),w)-3.8,15,...
            optimoptions('fsolve','Display','none'))*180/pi;
        break
    elseif tmp>V_max
        V_stall_trate(itr)=V_max;
        om_max=fsolve(@(w)  W0(19)*gturn(hi,V_max,omdom(itr))^2-(1/2*p(hi)*V_max^2*S*CLmax),0.2,...
        optimoptions('fsolve','Display','none'))*180/pi;
        break
    else
        V_stall_trate(itr)=tmp;
    end
end
if isempty(om_max)
    om_max=omdom(end)*180/pi;
end

% Max Structural Lift
int_dom=[mdom(mdom>V_stall_trate(end)/a(hi) & mdom*a(hi)<V_max),V_max/a(hi)];
if V_stall_trate(end)<V_max
    int_dom=[V_stall_trate(end)/a(hi),int_dom];
end
for itr=1:length(int_dom)
    trate38(itr)=fsolve(@(w) gturn(hi,int_dom(itr)*a(hi),w)-3.8,20,...
        optimoptions('fsolve','Display','none'))*180/pi;
end

%PLOT BOUNDARIES
plot(V_max/a(hi)*[1 1],[0 min(V_max_trate,om_max)],'m-','LineWidth',1.6)
plot(int_dom,trate38,'m-','LineWidth',1.6)
plot(V_stall_trate/a(hi),[omdom(1:length(V_stall_trate)-1)*180/pi,om_max],'m-','LineWidth',1.6)

%% Touches
%labeling
xlabel('Mach'); ylabel('Turn Rate deg/sec')
title('Specific Excess Power and \color{blue}G-turn \color{black}and \color{magenta}Level Flight Envelope \color{black}at Sea Level')
ylim([0 omdom(end)*180/pi])