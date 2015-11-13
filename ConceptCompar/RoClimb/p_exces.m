%% Power Avaliabe and Required

clear; clc
load('../constants.mat')


vres=60;
vdom=linspace(20,350,vres)*1.4666;
vdom=reshape(vdom,[vres,1]); % make column vector
hdom=[0 18e3 24e3];

% Power Required
P=@(v,h) 0.5*v.^3*p(h)*S*Cd0+K*W0(19)^2./(0.5*v*p(h)*S);
pr=P(vdom,hdom);

% Power Avalible
fl1=cd;
cd ../Takeoff
T=proppower(6,Pa);
cd(fl1)
pa=vdom.*T(vdom)*sqrt(p(hdom)/p(0));

% Plot
figure(1); clf
plot(vdom/1.4666,(pa-pr)/W0(19))
title('Excess Power')
grid on; xlabel('Velocity, mph'); ylabel('P/W')
yl=ylim;
ylim([max(yl(1),-40) yl(2)])
legend({'Sea Level','18,000 ft','24,000 ft'})