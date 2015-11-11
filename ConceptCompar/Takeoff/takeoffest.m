clear; clc

load('../constants.mat')
load('takeoff_const.mat')
Pa=Pa*0.9; % 90% power for takeoff

RTOL=1e-4;

n=6; %number of engines
T=proppower(n,Pa);

%% Ground Run
nm=1; % Running with full power
[t,r]=ode45(@groundrun,[0 360],[W0(19),0.1,0],...
    odeset('RelTol',RTOL),nm,T);

t=t(diff(r(:,1))~=0);
r=r(diff(r(:,1))~=0,:);

Wt=r(:,1);
Vt=r(:,2);
St=r(:,3);

%% Stopping Distance
% as Lift determines normal forces
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end


parfor itr=1:length(t)
    [tSss,Sss]=ode45(@sbrake,[0 150],[Vt(itr),St(itr),Wt(itr)],...
        odeset('RelTol',RTOL*10));
    Sst=Sss(Sss(:,1)~=0,:);
    tSst=tSss(Sss(:,1)~=0);
    S_b(itr,1)=Sst(end,2);
    t_b(itr,1)=tSst(end);
end

[~,ind]=min(abs(3000-S_b));
vtF=griddedInterpolant((ind-5:ind+5),Vt(ind-5:ind+5));
stF=griddedInterpolant((ind-5:ind+5),St(ind-5:ind+5));
wtF=griddedInterpolant((ind-5:ind+5),Wt(ind-5:ind+5));
newres=50;
vtdom=vtF(linspace(ind-5,ind+5,newres));
stdom=stF(linspace(ind-5,ind+5,newres));
wtdom=wtF(linspace(ind-5,ind+5,newres));


parfor itr=1:newres
    [tSss,Sss]=ode45(@sbrake,[0 150],[vtdom(itr),stdom(itr),wtdom(itr)],...
        odeset('RelTol',RTOL));
    Sst=Sss(Sss(:,1)~=0,:);
    tSst=tSss(Sss(:,1)~=0);
    S_b2(itr,1)=Sst(end,2);
    t_b2(itr,1)=tSst(end);
end

[~,ind]=min(abs(3000-S_b2));
[~,Sbr_disp]=ode45(@sbrake,[0 150],[vtdom(ind),stdom(ind),wtdom(ind)],...
    odeset('RelTol',RTOL)); % for graphout
    
%% One Engine Inoperable
% Worst Case Scenario, engine out at S_br
nm=(n-1)/n; % running OEI
[t_oei,r_oei]=ode45(@groundrun,[0 100],[Wt(ind),Vt(ind),St(ind)],...
    odeset('RelTol',RTOL),nm,T);
t_oei=t_oei(diff(r_oei(:,1))~=0)+t(ind);
r_oei=r_oei(diff(r_oei(:,1))~=0,:);

Wt_oei=r_oei(:,1);
Vt_oei=r_oei(:,2);
St_oei=r_oei(:,3);

%% Airborne Distance
V2=max(172,Vstall*1.2); % ft/s, Vmp for climbing
Vlof=1.1*Vstall;
Sa=Wt(end)/(Pa/V2-0.5*p(0)*V2^2*S*Cdg)*((V2^2-Vlof^2)/(2*32.2)+35);
Sa_oei=Wt_oei(end)/(nm*Pa/V2-0.5*p(0)*V2^2*S*Cdg)*((V2^2-Vlof^2)/(2*32.2)+35);

%% Graphs

figure(1); clf
subplot(2,2,1:2)
plot(St,Vt/1.4666); xlabel('Dist, ft'); ylabel('Vel, mph')
hold on
plot(Sbr_disp(:,2),Sbr_disp(:,1)/1.4666,'r')
plot(St_oei,Vt_oei/1.4666,'g')
plot(St(end)+Sa,V2/1.4666,'b*')
plot(St_oei(end)+Sa_oei,V2/1.4666,'g*')
legend({'Takeoff','Emerg Brake','OEI'},'Location','south')
grid on

subplot(2,2,3)
plot(St,t); xlabel('Dist, ft'); ylabel('time, s')
hold on
plot(St_oei,t_oei,'g')
plot(St(end)+Sa,t(end)+Sa/V2,'b*')
plot(St_oei(end)+Sa_oei,t_oei(end)+Sa_oei/V2,'g*')
plot(St(ind),t(ind),'r*')
grid on

subplot(2,2,4)
plot(S_b,Vt/1.4666,'r')
hold on
plot(St,Vt/1.4666,'b')
xlabel('Dist, ft'); ylabel('Vel, mph')
legend({'Braking','Takeoff'})
grid on

save('outdat.mat','t','Wt','Vt','St','Sbr_disp','Sa')