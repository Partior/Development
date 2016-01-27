clear; clc
load('../constants.mat')

[t,r]=ode45(@w_climb,[0 1500],[0,W0(19)],...
    odeset('RelTol',RT),20e3);  %with 20e3 being the cruise alti
ind=find(diff(r(:,2))>=0)-1;
t=t(1:ind);
r=r(1:ind,:);

vend=(K*r(end,2).^2./(1/2*p(r(end,1)).^2*S^2*Cd0)).^(1/4);
[t2,r2]=ode45(@w_leveloff,[0 400],[r(end,:),vend],...
    odeset('RelTol',RT));
ind=find(diff(r2(:,2))>=0)-1;
t2=t2(1:ind);
r2=r2(1:ind,:);

r1=[r,(K*r(:,2).^2./(1/2*p(r(:,1)).^2*S^2*Cd0)).^(1/4)];

tc=[t;t2+t(end)];
rc=[r1;r2];

figure(1); clf
subplot(2,2,1)
plot(tc,rc(:,1)/1e3)
xlabel('Time, sec'); ylabel('Altitde, 1,000 ft')
subplot(2,2,2)
plot(tc,rc(:,3)/1.4666)
xlabel('Time, sec'); ylabel('Velocity, mph')
subplot(2,2,3)
plot(tc,rc(:,2))
xlabel('Time, sec'); ylabel('Weight, lbs')
subplot(2,2,4)
plot(tc(1:end-1),diff(rc(:,2))./diff(tc));
xlabel('Time, sec'); ylabel('Fuel Flow, lb/sec')