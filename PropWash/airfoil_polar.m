%% Drag Polar for Airfoil
% Using xfoil for NACA 23015

dta=importdata('C:\Users\granataa\Desktop\Classes\15 Fall\Design\xfoil\naca_polar.txt',' ',12);

alfa=dta.data(:,1);
cl=dta.data(:,2);
cd=dta.data(:,3);
cm=dta.data(:,5);

Cd0=min(cd);

Cla=griddedInterpolant(alfa(4:end),cl(4:end),'pchip','none');
Cda=griddedInterpolant(alfa(4:end),cd(4:end),'pchip','none');