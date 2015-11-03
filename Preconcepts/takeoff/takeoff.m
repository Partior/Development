VTO=85*1.46666*1.2; % V_TO = 1.2*vstall, setting vstall to 85 mph
p_sl=2.3769e-3; %slugs/ft^3, sea level density


figure(1); clf
[d,n]=meshgrid(linspace(1.5,7,15),[6:12]);
p=1600*550;
% factor of 0.25 is selected from average of mutlibladed propellers
T0=0.25*(p./n.*d).^(2/3);
T0t=T0.*n;
a=((p/VTO)-T0t)/(VTO)^2;

rest=0.04; % Firm Turf
Cdg=0.0527; %Ground roll drag
CLg=1.7; % max ground lift
Wto=16000; % Weight at takeoff
WS=35; % wingloading
A=32.2*(T0t/Wto-rest);
B=32.2/Wto*(0.5*p_sl*(Wto/WS)*(Cdg-rest*CLg)+a);
s=1./(2*B).*log(A./(A-B*(VTO)^2));
mesh(d,n,s,'FaceColor','none')
xlabel('Blade Diameter, ft')
ylabel('Number of Engines')
zlabel('Takeoff Ground Roll, ft')
title(sprintf('%.0f hp total propulsion',p/550))

% mach tips
figure(2); clf
mdia=0.85*1125.33./([1500:50:5000]/60)/pi; %1125.33 ft/s is mach1
plot(1500:50:5000,mdia)
mdia2=0.85*1125.33./sqrt((([1500:50:5000]/60)/pi).^2+VTO^2);
hold on
plot(1500:50:5000,mdia2)
xlabel('rpm')
ylabel('Max Diameter, ft')
title('Max Diameter for M=0.85')
legend({'Static','V_{TO}'})

figure(3); clf
mesh(d,n,T0t,'FaceColor','none')
xlabel('Blade Diameter, ft')
ylabel('Number of Engines')
zlabel('Total Static Thrust')