%% Drag Polar for Airfoil
% Using xfoil for NACA 23015, gather and develop the Lift curve, the Drag
% curve, and Cd_0 and Zero-lift AoA

dta=importdata(airfoil_polar_file,' ',12);

alfa=dta.data(:,1);
cl=dta.data(:,2);
CD=dta.data(:,3);
cm=dta.data(:,5);

Cd0=min(CD);

Cla=griddedInterpolant(alfa(4:end),cl(4:end),'pchip','none');
Cda=griddedInterpolant(alfa(4:end),CD(4:end),'pchip','none');
Cl0=fzero(@(a) Cla(a),-1);