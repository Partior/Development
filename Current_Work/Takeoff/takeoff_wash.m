%% Takeoff estimation with PropWash effects
clear all; clc

addpath('../')
add_Paths

%% INIT
prop_const

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

Cda=@(a) Cda(a)-0.0016; % equation 20 from http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf
equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

mu=0.02;    % rolling resistance
muTire=0.55;    % Braking resistance,
VLOF=fsolve(@(v) L(max(cell2mat(Cla.GridVectors))-incd,0,v,8)-W0(19),150,...
    optimoptions('fsolve','display','none')); % liftoff speed to which ground run goes to
VLOF=162; % While we work out the completed Lift Polar, using C_l=1.7;
ne=8;   % all engines

save('takeoff_const.mat')
%% Ground Run
global Tmat Drmat Dgmat tmat itrcyc
Tmat=0; Drmat=0; Dgmat=0; tmat=0;
itrcyc=0;
nm=1; % Running with all engines
opts=odeset('OutputFcn',@outfun,'Events',@events_grnd_wash,'RelTol',1e-3);
[t,r]=ode45(@groundrun_wash,[0 360],[W0(19),0.1,0],opts,nm,ne);

Wt=r(:,1);
Vt=r(:,2);
St=r(:,3);

%% Stopping Distance
% as Lift determines normal forces
poolobj = gcp('nocreate'); % If parpool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

itr1=find(Vt>5,1,'first');
% determine stopping distances for every instance from the ground run
parfor itr=itr1:length(t)
    [tSss,Sss]=ode45(@sbrake_wash,[0 45],[Wt(itr),Vt(itr),St(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-4),ne);
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
newres=11;
tdom=tF(linspace(ind-1,ind+1,newres));
vtdom=vtF(linspace(ind-1,ind+1,newres));
stdom=stF(linspace(ind-1,ind+1,newres));
wtdom=wtF(linspace(ind-1,ind+1,newres));

% rerun decision point at newer resoltuion
parfor itr=1:newres
    [tSss,Sss]=ode45(@sbrake_wash,[0 45],[wtdom(itr),vtdom(itr),stdom(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-3),ne);
    S_b2(itr,1)=Sss(end,3);
    t_b2(itr,1)=tSss(end);
end

 % for graphout
[~,ind]=min(abs(3000-S_b2));    % determine more presicion decision point
[tbr_disp,Sbr_disp]=ode45(@sbrake_wash,[0 45],[wtdom(ind),vtdom(ind),stdom(ind)],...
    odeset('Events',@events_sbrk_wash,'RelTol',1e-4),ne);

%% One Engine Inoperable
% Worst Case Scenario, engine out at S_br
nm=(n-1)/n; % running OEI
[t_oei,r_oei]=ode45(@groundrun_wash,[0 360],[Wt(1),Vt(1),St(1)],...
    odeset('Events',@events_grnd_wash,'RelTol',1e-3),nm,ne);

Wt_oei=r_oei(:,1);
Vt_oei=r_oei(:,2);
St_oei=r_oei(:,3);

%% Airborne Distance
global gmmat tmat_a
gmmat=0; tmat_a=0; itrcyc=0;
nm=1;
opts_a=odeset('OutputFcn',@outfun_a,'Events',@events_airborne_wash,'RelTol',1e-3);
[t_a,r_a]=ode45(@airborne_wash,[0 50],[r(end,:),0,0],opts_a,nm,ne);

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

beep