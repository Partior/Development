%% High Angle of Attack Thrust Contrubutions
% Assuming zero incidence angle
% Looks at variations on Lift and Drag due to thrust being offset

clear; clc
load('../constants.mat')
vdom=linspace(10,350)*1.4666;

%% Basic Equations
% Assuming Steady, Level Flight
% 
% Flight Path is Horizontal: $\gamma = 0$
% 
% Thrust invaraint with AoA: $dT_{\alpha} = 0$
% 
% $$\vec{L}=\hat{k}\{L\}$$
% 
% $$\vec{D}=\hat{i}\{-D\}$$
% 
% Thrust is function of attack angle
% 
% $$\vec{T} = \hat{i}\{\cos(\alpha)T\}+\hat{k}\{\sin(\alpha)T\}$$
% 
% Summing Forces:
% 
% $$\Sigma F_{\hat{k}} = L + \cos(\alpha)T - W$$
% 
% $$\Sigma F_{\hat{i}} = -D + \sin(\alpha)T$$

%% Thrust Invariant Calculations
CLa=2*pi*pi/180;   % Slope of CL per alpha (2*pl Cl per radian),
% assume symmetric airfoil (Cl_0=0)
Cl_old=W0(19)./(1/2*p(0)*S*vdom.^2);
a_old=Cl_old/CLa;
D_old=(Cd0+K*(CLa*a_old).^2)*1/2*p(0).*vdom.^2*S;
vmin_ind=find(a_old>15,1,'last');
plvl=D_old./(Pa./vdom);

%% Thrust Variant Calculations

% x(1)=v, x(2)=power setting
t_solver=@(al) ...
    [-(2^(1/2)*(Cd0*sind(al) - CLa*al*cosd(al) + CLa^2*K*al^2*sind(al))*(-(W0(19)^3*cosd(al))/(S*p(0)*(Cd0*sind(al) - CLa*al*cosd(al) + CLa^2*K*al^2*sind(al))^3))^(1/2))/W0(19);...
    (2^(1/2)*(K*CLa^2*al^2 + Cd0)*(-(W0(19)^3*cosd(al))/(S*p(0)*(Cd0*sind(al) - CLa*al*cosd(al) + CLa^2*K*al^2*sind(al))^3))^(1/2))/Pa];

for itr=1:length(a_old)
    ali=a_old(itr);
    v_new(itr,:)=t_solver(ali);
end
tlim_ind=find(v_new(:,2)<=1,1,'last');


%% Plot
figure(1); clf

% Velocity to Power level
subplot(2,2,1); hold on
plot(vdom/1.4666,100*plvl)
yl=ylim;
plot([1;1]*vdom([vmin_ind,tlim_ind])/1.4666,[0 yl(2)],'r--')
ylim(yl)
xlabel('Velocity'); ylabel('Power Level, %')
grid on

% AoA to Change in Power
subplot(2,2,2)
plot(a_old(vmin_ind:tlim_ind),100*(v_new(vmin_ind:tlim_ind,2)'-plvl(vmin_ind:tlim_ind)))
xlabel('\alpha, deg'); ylabel('\Delta P_{lvl} %')
grid on

% Chaing in AoA for velocity
AV=griddedInterpolant(vdom(vmin_ind:tlim_ind),a_old(vmin_ind:tlim_ind));
a_new=AV(v_new(vmin_ind:tlim_ind,1));
subplot(2,2,3)
plot(vdom(vmin_ind:tlim_ind)/1.4666,a_new'-a_old(vmin_ind:tlim_ind))
xlabel('Velocity, mph'); ylabel('\Delta \alpha, deg')

% Velocity to Change in Power
plvl_new=interp1(a_new,v_new(vmin_ind:tlim_ind,2),a_old(vmin_ind:tlim_ind));
subplot(2,2,4)
plot(vdom(vmin_ind:tlim_ind)/1.4666,100*(plvl_new-plvl(vmin_ind:tlim_ind)))
xlabel('Velocity, mph'); ylabel('\Delta P_{lvl} %')
