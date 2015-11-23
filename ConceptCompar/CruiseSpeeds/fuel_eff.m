%% Fuel Efficiency versus Velocity and Altitude

clear; clc
load('../constants.mat')
Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second

beta=@(m) sqrt(1-m.^2);
cd=@(v,h) Cd0./beta(v./a(h));

%% Domain Setup
hdom=linspace(0,45)*1e3;
mdom=linspace(0,0.6);
[h_msh,m_msh]=meshgrid(hdom,mdom);

pay=19; % number of Passengers to graph for

v_msh=m_msh.*a(h_msh);
vdom=mdom.*a(hdom);

%% Mesh Calcultations
gmma=@(v,h,py) v./(SFC/3600*(cd(v,h)*S.*v.^2.*p(h)*1/2+2*K*W0(py)^2./(S*v.^2.*p(h))));
plvl=@(v,h,py) (0.5*v.^3.*p(h)*S.*cd(v,h)+K*W0(py)^2./(0.5*v.*p(h)*S))./(Pa*sqrt(p(h)/p(0)));

gmma_m=gmma(v_msh,h_msh,pay);
plvl_m=(0.5*v_msh.^3.*p(h_msh)*S.*cd(v_msh,h_msh)+K*W0(pay)^2./(0.5*v_msh.*p(h_msh)*S))./(Pa*sqrt(p(h_msh)/p(0)));

%% Optima Calculations
hsc=log(p(40e3)/p(0))/(40e3);
dg2=@(V,h,W) 1.5528616e27*V^6*exp(-0.000096*h) - 1.0676833e22*V^6*h*exp(-0.000096*h) - 4.6661618e28*V^2*W^2*exp(-0.000032*h)*((4.3980465e22*V^2 + 3.7692584e23*h - 5.4820909e28)/(3.7692584e23*h - 5.4820909e28))^(3/2) + 3.2082594e23*V^2*W^2*h*exp(-0.000032*h)*((4.3980465e22*V^2 + 3.7692584e23*h - 5.4820909e28)/(3.7692584e23*h - 5.4820909e28))^(3/2);

for itr=1:100
    m_opt_m(itr)=fsolve(@(v) dg2(v,hdom(itr),W0(pay)),500,...
        optimoptions('fsolve','Display','off'))/a(hdom(itr));
end

%% Boundaries:
sP=@(h,v,n,py) (Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*cd(v,h)+K*n.^2*W0(py)^2./(0.5*v.*p(h)*S)))/W0(py);
% Stall Speed
CLmax=1.6;
hinter_m=fsolve(@(h) sP(h,sqrt(W0(pay)./(1/2*p(h)*S*CLmax)),1,pay),40e3,optimoptions('fsolve','Display','off'));
hdom3_m=[hdom(hdom<hinter_m),hinter_m];
v_stall_m=sqrt(W0(pay)./(1/2*p(hdom3_m)*S*CLmax));

% Service Ceiling
V_mp=@(h) (K*W0(pay)^2./(3/4*Cd0*p(h).^2*S^2)).^(1/4);                            
h_sc_m=fsolve(@(h) sP(h,V_mp(h),1,pay)-100/60,40e3,optimoptions('fsolve','Display','off')); 

%% Plotting
figure(2); clf; hold on
ax1=gca;
ax1.Color=0.5*[1 1 1];

% Fuel Consumption
gmdom=0:0.05:1;
gmint=[0.25 0.5 0.75];
for itr=1:length(gmdom)
    if any(abs(gmdom(itr)-gmint)<1e-8)
        gmdom(itr)=0;
    end
end
gmdom=nonzeros(gmdom);

[~,h2]=contour(m_msh,h_msh/1e3,gmma_m/5280,gmdom);
set(h2,'LineColor','r','LineStyle',':','LineWidth',1);

[~,h]=contour(m_msh,h_msh/1e3,gmma_m/5280,gmint);
set(h,'LineColor','r','LineStyle','-','LineWidth',1.5,...
    'ShowText','on')

ylm=ylim;
xlm=xlim;
plot(m_opt_m,hdom/1e3,'c','LineWidth',1.5)

plot(v_stall_m./a(hdom3_m),hdom3_m/1e3,'b-','LineWidth',1.4)
plot(mdom([1,end]),h_sc_m*[1,1]/1e3,'m--')
ylim(ylm)
xlim(xlm)

% Power Levels
pldom=0.4:0.1:1.25;
plint=[0.5 0.75 1];
for itr=1:length(pldom)
    if any(abs(pldom(itr)-plint)<1e-8)
        pldom(itr)=0;
    end
end
pldom=nonzeros(pldom);

[~,h3]=contour(m_msh,h_msh/1e3,plvl_m*100,pldom*100);
set(h3,'LineColor','k','LineStyle',':','LineWidth',1);

[~,h4]=contour(m_msh,h_msh/1e3,plvl_m*100,plint*100);
set(h4,'LineColor','k','LineStyle','-','LineWidth',1.5,...
    'ShowText','on')

%% Pretty
yl='Altitude, 1,000 ft';
xl='Mach';
t0=sprintf('fuel Eggiciency, %g Passengers',pay);
tl='\color{red}Miles Per Pound Fuel\color{black}, \color{black}Power Setting \color{black} and \color{cyan}Optima Line';
tl2='\color{blue}Stall Line\color{black}, \color{magenta}Service Ceiling';
xlabel(xl); ylabel(yl)
<<<<<<< HEAD
title({t0;tl;tl2})
=======
title({'Fuel Efficiency, Max payload';tl;tl2})

%% Empty Plotting
figure(3); clf; hold on
ax2=gca;
ax2.Color=0.5*[1 1 1];

% Fuel Consumption
[~,h2e]=contour(m_msh,h_msh/1e3,gmma_e/5280,gmdom);
set(h2e,'LineColor','r','LineStyle',':','LineWidth',1);

[~,he]=contour(m_msh,h_msh/1e3,gmma_e/5280,gmint);
set(he,'LineColor','r','LineStyle','-','LineWidth',1.5,...
    'ShowText','on')

plot(m_opt_e,hdom/1e3,'c','LineWidth',1.5)

plot(v_stall_e./a(hdom3_e),hdom3_e/1e3,'b-','LineWidth',1.4)
plot(mdom([1,end]),h_sc_e*[1,1]/1e3,'m--')
ylim(ylm)
xlim(xlm)

% Power Levels
[~,h3e]=contour(m_msh,h_msh/1e3,plvl_e*100,pldom*100);
set(h3e,'LineColor','k','LineStyle',':','LineWidth',1);

[~,h4e]=contour(m_msh,h_msh/1e3,plvl_e*100,plint*100);
set(h4e,'LineColor','k','LineStyle','-','LineWidth',1.5,...
    'ShowText','on')

%% Pretty
xlabel(xl); ylabel(yl)
title({'Fuel Efficiency, Empty payload';tl;tl2})
>>>>>>> 4ed8a89e120cba0002ed3a0a8889befbecdcf4cc
