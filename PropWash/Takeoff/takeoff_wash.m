%% Takeoff estimation with PropWash effects
clear; clc

addpath('../')

%% INIT


clear; clc
load('C:\Users\granata\Desktop\MATLAB Files\Partior\ConceptCompar\constants.mat')

AR=15;
S=200;
n=8;

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

mu=0.05;    % rolling resistance
muTire=0.35;    % Braking resistance, tires to grass
VLOF=100*1.4666; % liftoff speed to which ground run goes to
ne=n;   % all engines

save('takeoff_const.mat')
%% Ground Run
nm=1; % Running with all engines
[t,r]=ode45(@groundrun_wash,[0 20],[W0(19),0.1,0],...
    odeset('Events',@events_grnd_wash,'RelTol',1e-2),...
    nm,ne);

Wt=r(:,1);
Vt=r(:,2);
St=r(:,3);

%% Stopping Distance
% as Lift determines normal forces
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

itr1=find(Vt>5,1,'first');
% determine stopping distances for every instance from the ground run
parfor itr=itr1:length(t)
    [tSss,Sss]=ode45(@sbrake_wash,[0 10],[Wt(itr),Vt(itr),St(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-3),ne);
    S_b(itr,1)=Sss(end,3);
    t_b(itr,1)=tSss(end);
end

[~,ind]=min(abs(3000-S_b)); % determine where decision point + stopping is 3000 ft
if ind==1;
    ind=2;
elseif ind==length(t)
    ind=length(t)-1;
end
tF=griddedInterpolant((ind-1:ind+1),t(ind-1:ind+1));
vtF=griddedInterpolant((ind-1:ind+1),Vt(ind-1:ind+1));
stF=griddedInterpolant((ind-1:ind+1),St(ind-1:ind+1));
wtF=griddedInterpolant((ind-1:ind+1),Wt(ind-1:ind+1));
% higher resoultion executions for approximateion of decison point
newres=20;
tdom=tF(linspace(ind-1,ind+1,newres));
vtdom=vtF(linspace(ind-1,ind+1,newres));
stdom=stF(linspace(ind-1,ind+1,newres));
wtdom=wtF(linspace(ind-1,ind+1,newres));

% rerun decision point at newer resoltuion
parfor itr=1:newres
    [tSss,Sss]=ode45(@sbrake_wash,[0 40],[wtdom(itr),vtdom(itr),stdom(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-3),ne);
    S_b2(itr,1)=Sss(end,3);
    t_b2(itr,1)=tSss(end);
end

[~,ind]=min(abs(3000-S_b2));    % determine more presicion decision point
[tbr_disp,Sbr_disp]=ode45(@sbrake_wash,[0 40],[wtdom(ind),vtdom(ind),stdom(ind)],...
    odeset('Events',@events_sbrk_wash,'RelTol',1e-6),ne); % for graphout

%% One Engine Inoperable
% Worst Case Scenario, engine out at S_br
nm=(n-1)/n; % running OEI
% [t_oei,r_oei]=ode45(@groundrun_wash,[0 40],[wtdom(ind),vtdom(ind),stdom(ind)],...
%     odeset('Events',@events_grnd_wash,'RelTol',1e-2),nm,ne);
% t_oei=t_oei+tdom(ind);
[t_oei,r_oei]=ode45(@groundrun_wash,[0 20],[Wt(1),Vt(1),St(1)],...
    odeset('Events',@events_grnd_wash,'RelTol',1e-2),nm,ne);

% if isempty(r_oei)
%     t_oei=t(ind);
%     Wt_oei=wtdom(ind);
%     Vt_oei=vtdom(ind);
%     St_oei=stdom(ind);
% else
    Wt_oei=r_oei(:,1);
    Vt_oei=r_oei(:,2);
    St_oei=r_oei(:,3);
% end

%% Airborne Distance
V2=max(172,VLOF*1.1); % ft/s, Vmp for climbing
Cdg=D(3,0,V2,ne)/(0.5*p(0)*V2^2*S);
Sa=Wt(end)/(Pa/V2-0.5*p(0)*V2^2*S*Cdg)*((V2^2-VLOF^2)/(2*32.2)+35); % airborne distance
Sa_oei=Wt_oei(end)/(nm*Pa/V2-0.5*p(0)*V2^2*S*Cdg)*((V2^2-VLOF^2)/(2*32.2)+35); % airborne with oei

%% Graphs

figure(1); clf
subplot(2,2,1:2)
plot(St,Vt/1.4666); xlabel('Dist, ft'); ylabel('Vel, mph')
hold on
plot(Sbr_disp(:,3),Sbr_disp(:,2)/1.4666,'r')
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
plot(Sbr_disp(:,3),tbr_disp+tdom(ind),'r')
grid on

subplot(2,2,4)
plot(S_b-St,Vt/1.4666,'r')
xl=xlim; xlim([0 xl(2)])
hold on
plot(St,Vt/1.4666,'b')
xlabel('Dist, ft'); ylabel('Vel, mph')
legend({'Braking','Takeoff'},'location','south')
grid on