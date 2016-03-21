%% TESTER

load('../constants.mat')

itp=pyc;
ith=floor(hc/2);

clc=W0(pdom(itp))/(0.5*p(hdom(ith))*S*V0^2);
cdc=0.02+K*clc^2;
T=0.5*p(hdom(ith))*V0^2*S*cdc; %constant thrust flight


%% ROUND 1
[t,r]=ode45(@DR,[0 800*60],...
    [0,V0,W0(pdom(itp)),pdom(itp),p(hdom(ith))],...
    odeset('RelTol',1e-2));
t=t(diff(r(:,1))~=0);
r=r((diff(r(:,1))~=0),:);

t=t/60;
R=r(:,1)/5280;
V=r(:,2)/1.4666;
W=r(:,3);

figure(1); clf
subplot(2,2,1); plot(t,R)
xlabel('Time, min'); ylabel('Range, Miles')
subplot(2,2,2); plot(t,V)
xlabel('Time, min'); ylabel('Vel, mph')
subplot(2,2,3); plot(t(2:end),diff(W)./diff(t*60))
xlabel('Time, min'); ylabel('\delta W')
subplot(2,2,4); plot(t,W/1e3)
xlabel('Time, min'); ylabel('W, 1e3 lbs')

%% ROUND 2
[t,r]=ode45(@DR2,[0 800*60],...
    [0,V0,W0(pdom(itp)),pdom(itp),p(hdom(ith))],...
    odeset('RelTol',1e-2));
t=t(diff(r(:,1))~=0);
r=r((diff(r(:,1))~=0),:);

t=t/60;
R=r(:,1)/5280;
V=r(:,2)/1.4666;
W=r(:,3);

subplot(2,2,1); hold on; plot(t,R)
subplot(2,2,2); hold on; plot(t,V)
subplot(2,2,3); hold on; plot(t(2:end),diff(W)./diff(t*60))
subplot(2,2,4); hold on; plot(t,W/1e3)

%% ROUND 3
[t,r]=ode45(@DR3,[0 800*60],...
    [0,V0,W0(pdom(itp)),pdom(itp),p(hdom(ith))],...
    odeset('RelTol',1e-2));
t=t(diff(r(:,1))~=0);
r=r((diff(r(:,1))~=0),:);

t=t/60;
R=r(:,1)/5280;
V=r(:,2)/1.4666;
W=r(:,3);

subplot(2,2,1); hold on; plot(t,R)
subplot(2,2,2); hold on; plot(t,V)
subplot(2,2,3); hold on; plot(t(2:end),diff(W)./diff(t*60))
subplot(2,2,4); hold on; plot(t,W/1e3)

%% ROUND 4
[t,r]=ode45(@DR4,[0 800*60],...
    [0,V0,W0(pdom(itp)),pdom(itp),p(hdom(ith))],...
    odeset('RelTol',1e-2));
t=t(diff(r(:,1))~=0);
r=r((diff(r(:,1))~=0),:);

t=t/60;
R=r(:,1)/5280;
V=r(:,2)/1.4666;
W=r(:,3);

subplot(2,2,1); hold on; plot(t,R)
legend({'Thrust','AoA','Vel','Power'},'Location','southeast')
subplot(2,2,2); hold on; plot(t,V)
subplot(2,2,3); hold on; plot(t(2:end),diff(W)./diff(t*60))
subplot(2,2,4); hold on; plot(t,W/1e3)