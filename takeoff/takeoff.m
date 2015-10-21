VTO=85*1.46666*1.2; % V_TO = 1.2*vstall, setting vstall to 90 mph
p_sl=2.3769e-3; %slugs/ft^3, sea level density


figure(1); clf
[d,n]=meshgrid(linspace(1.5,7,15),[6:12]);
p=1600*550;
% factor of 0.25 is selected from average of mutlibladed propellers
T0=0.25*(p./n.*d).^(2/3);
T0t=T0.*n;
a=((p/VTO)-T0t)/(VTO)^2;
A=32.2*(T0t/15000-0.04);
rest=0.04; % Firm Turf
Cdg=0.0527; %Ground roll drag
CLg=1.7; % max ground lift
Wto=15000; % Weight at takeoff
WS=30; % wingloading
B=32.2/Wto*(0.5*p_sl*(Wto/WS)*(Cdg-rest*CLg)+a);
s=1./(2*B).*log(A./(A-B*(VTO)^2));
mesh(d,n,s)
xlabel('Blade Diameter, ft')
ylabel('Number of Engines')
zlabel('Takeoff Distance, ft')
title('1200 hp total propulsion')

% mach tips
figure(2); clf
mdia=0.85*1125.33./([1500:50:5000]/60)/pi; %1125.33 ft/s is mach1
plot(1500:50:5000,mdia);
xlabel('rpm')
ylabel('Max Diameter, ft')
title('Max Diameter for M=0.85 in static conditions')