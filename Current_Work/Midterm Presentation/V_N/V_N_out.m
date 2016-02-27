%% V-N Diagram and Flight Envelope

clear; clc

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash

n_e=2;
h=0;

% dCLa/da via DATCOM
beta=@(m) sqrt(1-m.^2);
sweep_ang=0;
CLa=@(m) 2*pi*AR./(2+sqrt(AR^2*beta(m).^2/0.97^2.*(1+tan(sweep_ang)^2./beta(m).^2)+4));

%% Domain
% Velocity, mach number
mres=250;   % resolution
mdom=linspace(0,0.5,mres);

nmax=3.8;   % strucutural limits
nnmax=-nmax*0.4;    % negitive manuevers
Clmax=max(Cla.Values);  % Max design lift coefficient
optsopt=optimoptions('fsolve','display','none');
aamx=fsolve(@(aa) Cla(aa)-Clmax,8,optsopt)-incd;
aamn=fsolve(@(aa) Cla(aa)-Clmax*0.6,3,optsopt)-incd;

%% Key Velocity Points
% Maneuvering Speed
Vau=fsolve(@(v) L(aamx,h,v,n_e)-nmax*W0(19),400,optsopt);
inAu=find(mdom*a(h)<Vau,1,'last');
Val=fsolve(@(v) L(aamn,h,v,n_e)-(-nnmax)*W0(19),400,optsopt);
inAl=find(mdom*a(h)<Val,1,'last');
% Cruise Speed
Vc=250*1.4666;
inC=find(mdom*a(h)<Vc,1,'last');
% Max Speed
Vd=Vc*1.4;   % as defined by FAR
inD=find(mdom*a(h)<Vd,1,'last');

Vs_u=fsolve(@(v) L(aamx,h,v,n_e)-W0(19),160,optsopt);   % upper stall speed
ns_u=L(aamx,h,Vs_u,n_e)/W0(19);
Vs_l=fsolve(@(v) L(aamn,h,v,n_e)-W0(19),210,optsopt); % lower stall speed
ns_l=-L(aamn,h,Vs_l,n_e)/W0(19);

%% N Initial Calculations
% determining n purely through lift curve calculation
n_p=zeros(size(mdom));
n_n=n_p;
for itr=1:mres
    n_p(itr)=L(aamx,h,(mdom(itr)*a(h)),n_e)/W0(19);
    n_n(itr)=-L(aamn,h,(mdom(itr)*a(h)),n_e)/W0(19);
end
%% Gust Calculations
% http://adg.stanford.edu/aa241/structures/vn.html
mu_g=2*W0(19)/32.2./(p(h)*chrd*S*CLa(mdom)); %aircraft mass ratio
k_g=0.88*mu_g./(5.3+mu_g);  % coefficent
% gusts n-factore for given gust speed and airplane speed
n_g=@(vge,vmax) 1+[1;-1]*(k_g(mdom*a(h)<vmax)*vge.*(mdom(mdom*a(h)<vmax)*a(h)).*CLa(mdom(mdom*a(h)<vmax))*p(h)*S)/(2*W0(19)); % gust loading

gau=n_g(50,Vau); gau=gau(1,:);  % upper cornering speed
gal=n_g(50,Val); gal=gal(2,:);  % lower cornering speed
gc=n_g(66,Vc);  % cruise speed
gd=n_g(25,Vd);  % max speed

%% Final VN
% upper
nu=n_p;
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
nu(mdom*a(h)>Vd)=0; % Max Speed

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
nl(mdom*a(h)>Vd)=0; % Max Speed

%% Plot the thing

V_N_grapher