%% Drag Polar for Airfoil
% Using xfoil for NACA 23015

a=importdata('C:\Users\granataa\Desktop\Classes\15 Fall\Design\xfoil\naca_polar.txt',' ',12);

alfa=a.data(:,1);
cl=a.data(:,2);
cd=a.data(:,3);
cm=a.data(:,5);

Cd0=min(cd);