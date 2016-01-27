%% V-N Diagram and Flight Envelope

clear; clc
load('../constants.mat')

Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
% Compressibility
beta=@(m) sqrt(1-m.^2);
cd=@(v,h) Cd0./beta(v./a(h));
% CLa via DATCOM
sweep_ang=0;
CLa=@(m) 2*pi*AR./(2+sqrt(AR^2*beta(m).^2/0.97^2.*(1+tan(sweep_ang)^2./beta(m).^2)+4));

%% Domain
% Velocity, mach number
mres=250;   % resolution
mdom=linspace(0,0.6,mres);

nmax=3.8;   % strucutural limits
nnmax=-nmax*0.4;    % negitive manuevers
Clmax=1.6;  % Max design lift coefficient

%% Key Velocity Points
% Maneuvering Speed
Vau=sqrt(2*nmax*W0(19)/(p(0)*S*Clmax));
inAu=find(mdom*a(0)<Vau,1,'last');
Val=sqrt(2*(-nnmax)*W0(19)/(p(0)*S*(Clmax*0.6)));
inAl=find(mdom*a(0)<Val,1,'last');
% Cruise Speed
Vc=250*1.4666;
inC=find(mdom*a(0)<Vc,1,'last');
% Max Speed
Vd=Vc*1.4;   % as defined by FAR
inD=find(mdom*a(0)<Vd,1,'last');

Vs_u=sqrt(2*1*W0(19)/(p(0)*S*Clmax));   % upper stall speed
ns_u=(Vs_u).^2*1/2*p(0)*S*Clmax/W0(19);
Vs_l=sqrt(2*1*W0(19)/(p(0)*S*(Clmax*0.6))); % lower stall speed
ns_l=-(Vs_l).^2*1/2*p(0)*S*Clmax*0.6/W0(19);

%% N Initial Calculations
% determining n purely through lift curve calculation
n=(mdom*a(0)).^2*1/2*p(0)*S*Clmax/W0(19);
n_n=-(mdom*a(0)).^2*1/2*p(0)*S*(Clmax*0.6)/W0(19);

%% Gust Calculations
c=S/sqrt(S*AR); % Mean chord
mu_g=2*W0(19)/32.2./(p(0)*c*S*CLa(mdom)); %aircraft mass ratio
k_g=0.88*mu_g./(5.3+mu_g);  % coefficent
% gusts n-factore for given gust speed and airplane speed
n_g=@(vge,vmax) 1+[1;-1]*(k_g(mdom*a(0)<vmax)*vge.*(mdom(mdom*a(0)<vmax)*a(0)).*CLa(mdom(mdom*a(0)<vmax))*p(0)*S)/(2*W0(19)); % gust loading

gau=n_g(50,Vau); gau=gau(1,:);  % upper cornering speed
gal=n_g(50,Val); gal=gal(2,:);  % lower cornering speed
gc=n_g(66,Vc);  % cruise speed
gd=n_g(25,Vd);  % max speed

%% Final VN
% upper
nu=n;
nu(nu>nmax)=nmax; % structure max
nu(nu<1)=0; % Below Stall Speeds
if gc(1,end)>nmax % Cruise Gusting
    % if true, changes V-N diagram from the level line for strucuural
    % failiure to a peak provided by two speperate linear relations to the
    % peak cruise gust back down to max speed gust
    nu(inAu:inC)=((gc(1,end)-nmax)/(mdom(inC)-mdom(inAu)))*...
        (mdom(inAu:inC)-mdom(inAu))+nu(inAu);    % to peak cruise gust
    dg=-(gc(1,end)-nmax)/((gd(1,end)-gc(1,end))/(mdom(inD)-mdom(inC)));
    indg=find(mdom<mdom(inC)+dg,1,'last');
    nu(inC:indg)=((gd(1,end)-gc(1,end))/(mdom(inD)-mdom(inC)))*...
        (mdom(inC:indg)-mdom(inC))+gc(1,end);
end
nu(mdom*a(0)>Vd)=0; % Max Speed

% lower
nl=n_n;
nl(nl<nnmax)=nnmax;   % structure max
nl(nl>-1)=0; % Below Stall Speeds
if gc(2,end)<nnmax % Cruise Gusting
    nl(inAl:inC)=((gc(2,end)-nnmax)/(mdom(inC)-mdom(inAl)))*...
        (mdom(inAl:inC)-mdom(inAl))+nl(inAl);    % to peak cruise gust
    dg=-(gc(2,end)-nnmax)/((gd(2,end)-gc(2,end))/(mdom(inD)-mdom(inC)));
    indg=find(mdom<mdom(inC)+dg,1,'last');
    nl(inC:indg)=((gd(2,end)-gc(2,end))/(mdom(inD)-mdom(inC)))*...
        (mdom(inC:indg)-mdom(inC))+gc(2,end);
end
nl(mdom*a(0)>Vd)=0; % Max Speed



%% Plot
figure(1); clf; hold on

plot(mdom,n,'r--')  % plot stall lift curve online line, upper
plot(mdom,n_n,'r--') % plot stall lift curve online line, lower

% stall locations
text(Vs_u/a(0),ns_u,'V_{stl up}','HorizontalAlignment','right','VerticalAlignment','bottom')
text(Vs_l/a(0),ns_l,'V_{stl dwn}','HorizontalAlignment','right','VerticalAlignment','top')
% cornering speed, upper
plot(Vau/a(0)*[1,1],[0,nmax],'k:')
text(Vau/a(0),0,'V_{crnr up}','HorizontalAlignment','center','VerticalAlignment','top')
% cornering speed, lower
plot(Val/a(0)*[1,1],[nmax*-0.4,0],'k:')
text(Val/a(0),0,'V_{crnr dwn}','HorizontalAlignment','center','VerticalAlignment','bottom')
% Cruise speed indicator
plot(Vc/a(0)*[1,1],[min(nmax*-0.4,gc(2,end)),max(nmax,gc(1,end))],'k:')
text(Vc/a(0),0,'V_{cruise}','HorizontalAlignment','center')
% Max speed indicator
plot(Vd/a(0)*[1,1],[nmax*-0.4,nmax],'k:')
text(Vd/a(0),0,'V_{max}','HorizontalAlignment','center')

plot(mdom(mdom*a(0)<Vau),gau,'b-.') % upper cornering gust
plot(mdom(mdom*a(0)<Val),gal,'b-.') % lower cornering gust
plot(mdom(mdom*a(0)<Vc),gc,'b-.')   % cruise gusts
plot(mdom(mdom*a(0)<Vd),gd,'b-.')   % max speed gusts

% Finally, plot the actuall curves of the VN diagram
plot(mdom,nu,'k-','LineWidth',1.5) 
plot(mdom,nl,'k-','LineWidth',1.5)

%% Pretty
xlabel('Mach'); ylabel('N Loading')
title({sprintf('V-N Diagram: N_{max} = %.1f',nmax);...
    'V-N Total, \color{red}Stall \color{black}and \color{blue}Gusts'})
ylim([min(nmax*-0.4,gc(2,end))*1.5 max(nmax,gc(1,end))*1.5])
grid on