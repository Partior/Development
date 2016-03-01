%% Drag Polar for Airfoil
% Using xfoil for NACA 23015, gather and develop the Lift curve, the Drag
% curve, and Cd_0 and Zero-lift AoA

[dta,~,~]=importdata(airfoil_polar_file);

alfa=dta.data(:,clms(1));
cl=dta.data(:,clms(2));
CD=dta.data(:,clms(3));
cm=dta.data(:,clms(4));

Cd0=min(CD);

Cla=griddedInterpolant(alfa(4:end),cl(4:end),'pchip','none');
Cda=griddedInterpolant(alfa(4:end),CD(4:end),'pchip','none');
Cl0=fzero(@(a) Cla(a),-1);

Cma=griddedInterpolant(alfa(4:end),cm(4:end),'pchip','none');