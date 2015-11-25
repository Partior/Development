%% Drag Polar for Airfoil
% Using xfoil for NACA 23015

dta=importdata('naca_polar.txt',' ',12);

alfa=dta.data(:,1);
cl=dta.data(:,2);
cd=dta.data(:,3);
cm=dta.data(:,5);

Cd0=min(cd);
Cl0=-1.1793;

Cla=griddedInterpolant(alfa(4:end),cl(4:end),'pchip','none');
Cda=griddedInterpolant(alfa(4:end),cd(4:end),'pchip','none');