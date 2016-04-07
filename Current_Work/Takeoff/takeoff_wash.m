%% Takeoff estimation with PropWash effects
clear all; clc

addpath('../')
add_Paths

%% INIT
prop_const

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar_file='210_30Flaps.txt';   %#ok<NASGU> % for Airborne
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
Cda=@(a) Cda(a)-0.0016; % equation 20 from http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf
equations_wash  % sets up lift and drag functions

VLOF=fsolve(@(v) L(Clmax-incd,0,v,8)-W0(19),200,...
    optimoptions('fsolve','display','none')); % liftoff speed to which ground run goes to

airfoil_polar_file='210_10Flaps.txt';   % for Ground run
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
Cda=@(a) Cda(a)-0.0016; % equation 20 from http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf
equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

mu=0.02;    % rolling resistance
muTire=0.55;    % Braking resistance,
save('takeoff_const.mat','mu','muTire','SFC_eq','Pa','L','T','Df','Dw','incd','Clmax','VLOF')
%% Ground Run
disp('Evaluating Ground Run')
ne=8;
opts=odeset('Events',@events_grnd_wash,'RelTol',1e-3);
[t,r]=ode45(@groundrun_wash,[0 40],[W0(19),0.1,0],opts,ne);

Wt=r(:,1);
Vt=r(:,2);
St=r(:,3);

%% Stopping Distance
disp('Evaluating Stopping Distance')
% as Lift determines normal forces
poolobj = gcp('nocreate'); % If parpool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

itr1=find(Vt>5,1,'first');
% determine stopping distances for every instance from the ground run
parfor itr=itr1:length(t)
    [tSss,Sss]=ode45(@sbrake_wash,[0 45],[Wt(itr),Vt(itr),St(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-2),ne);
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

disp('Evaluating Higher Resolution Stopping Distance')
% rerun decision point at newer resoltuion
parfor itr=1:newres
    [tSss,Sss]=ode45(@sbrake_wash,[0 45],[wtdom(itr),vtdom(itr),stdom(itr)],...
        odeset('Events',@events_sbrk_wash,'RelTol',1e-2),ne);
    S_b2(itr,1)=Sss(end,3);
    t_b2(itr,1)=tSss(end);
end

 % for graphout
[~,ind]=min(abs(3000-S_b2));    % determine more presicion decision point
[tbr_disp,Sbr_disp]=ode45(@sbrake_wash,[0 30],[wtdom(ind),vtdom(ind),stdom(ind)],...
    odeset('Events',@events_sbrk_wash,'RelTol',1e-4),ne);

%% One Engine Inoperable
disp('Evaluating OEI Ground Run')
% Worst Case Scenario, engine out at S_br
if ind==length(S_b2)
    ind=ind-2;
end
[t_oei,r_oei]=ode45(@groundrun_wash,[0 40],[wtdom(ind),vtdom(ind),stdom(ind)],...
    odeset('Events',@events_grnd_wash,'RelTol',1e-3),ne-1);

t_oei=t_oei+tdom(ind);
Wt_oei=r_oei(:,1);
Vt_oei=r_oei(:,2);
St_oei=r_oei(:,3);

%% Airborne Distance
airfoil_polar_file='210_30Flaps.txt'; % for Airborne
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
Cda=@(a) Cda(a)-0.0016; % equation 20 from http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf
equations_wash  % sets up lift and drag functions
disp('Evaluating Airborne Distances')
save('takeoff_const.mat','mu','muTire','SFC_eq','Pa','L','T','Df','Dw','incd','Clmax','VLOF')

opts_a=odeset('Events',@events_airborne_wash,'RelTol',1e-3);
[t_a,r_a]=ode45(@airborne_wash,[0 20],[r(end,:),0,0],opts_a,ne);
[t_aoei,r_aoei]=ode45(@airborne_wash,[0 20],[r_oei(end,:),0,0],opts_a,ne-1);

%% Graphs
disp('Graphing...')
figure(1); clf
subplot(4,1,1:3)
hold on
% regular run, ground then airborne
plot(St,Vt/1.4666,'b-')
plot(r_a(:,3),r_a(:,2)/1.4666,'c')
%OEI, ground then ariborne
plot(St_oei,Vt_oei/1.4666,'g')
plot(r_aoei(:,3),r_aoei(:,2)/1.4666,'m')
% E-Braking
plot(Sbr_disp(:,3),Sbr_disp(:,2)/1.4666,'r')
xlabel('Dist, ft'); ylabel('Vel, mph')
legend({'Ground Roll','Airborne','OEI Ground Roll','OEI Airborne','E-Braking'},'Location','south')
grid on

subplot(4,1,4)
hold on
% regular run, ground then airborne
plot(St,Vt/1.4666,'b')
plot(r_a(:,3),r_a(:,2)/1.4666,'c')
%OEI, ground then ariborne
plot(St_oei,Vt_oei/1.4666,'g')
plot(r_aoei(:,3),r_aoei(:,2)/1.4666,'m')
xlabel('Dist, ft'); ylabel('Vel, mph')
xl=xlim;
xlim([stdom(ind)-50 xl(2)]);
ylim('auto')
grid on

figure(2); clf
subplot(1,2,1)
hold on
plot(St,t,'b-'); 
plot(St_oei,t_oei+tdom(ind),'g-')
plot(r_a(:,3),t_a+t(end),'c')
plot(r_aoei(:,3),tdom(ind)+t_aoei,'m')
plot(Sbr_disp(:,3),tbr_disp+tdom(ind),'r')
xlabel('Dist, ft'); ylabel('time, s')
grid on

subplot(1,2,2)
hold on
plot(S_b-St,Vt/1.4666,'r')
plot(St,Vt/1.4666,'b')
xlabel('Dist, ft'); ylabel('Vel, mph')
xl=xlim; xlim([0 xl(2)])
legend({'Braking','Takeoff'},'location','south')
grid on