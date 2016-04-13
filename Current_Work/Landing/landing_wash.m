%% Landing
%  Look at the Landing phase of the flight in order to see how long it
%  takes to land on a strip.
%
% The Landing phase is described as thus:
%
%  Approach the landing strip, passing over 50ft obstacle
%
%  Descent at constant rate until 5 feet off ground
%
%  Instantly increase AoA such that rate of descent is now limited to 100
%  fpm
%
%  Touch down, AoA is whatever can be maintained by elevators and moments
%
%  Tire Brakes at 60-80 percent of braking power, add propeller braking
%
%  Run until V=0;

%% Startup
clear all; clc
prop_const

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar_file='Q1TOpolar.txt';
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

Cda=@(a) Cda(a)-0.0016; % equation 20 from http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf
equations_wash  % sets up lift and drag functions

muTire=0.55;    % Braking resistance
WLAND=W0(19)-0.9*Wf;
Vx=fzero(@(v) L(15,50,v,2)-WLAND,[100 200]);  % Velocity to maintain 15 deg AoA
%% Approach
S_a=50/tand(2.5);
t_a=S_a/(1.1*Vx);

%% Main Gear Down Setup
II=(W0(19)-0.9*Wf)/32.2*10.2956^2; % Mass moment of Inertia
Mw=@(aoa,h,v,on) ...
    1/2*p(h)*v.^2*Cma(aoa+incd)*((b-2*[2,on-2]*Rmax)*chrd)+...free stream wing lift
    1/2*p(h)*v2(v,CT(v,h,on),h,1).^2*Cma(incd)*((2*[2,0]*Rmax)*chrd)+... prop wash lift, cruise props
    1/2*p(h)*v2(v,TT(v,h,on),h,2).^2*Cma(incd)*((2*[0,on-2]*Rmax)*chrd);  %prop wash lift, takeoff props
CM=@(taoa,v) Mw(taoa,0,v,0)+L(taoa,0,v,2)*5.4+WLAND*-5+D(taoa,0,v,2)*10;
save('Landing/land_const.mat','II','CM','D','L','muTire','WLAND')

%% Main Gear Down
y0=[15;0;S_a;Vx];   % [AoA,r.o.rotat; S; V]
[t,r,te,ye,ie]=ode45(@landing_ode,[0 120],y0,...
    odeset('RelTol',1e-3,'Events',@events_lander));

%%
ylbl={'Angle of Attack, \alpha - deg';
    'Rate of Rotation, \omega -deg/s';
    'Distance Traveled, S - ft';
    'Velocity - ft/s'};
ylm=[0 15;-4 0;0 3000;0 Vx*1.1];
pltorder=[1,3,2,4];
for itr=1:4
    subplot(2,2,pltorder(itr))
    if itr<3
        plot(t_a+t(t<te(1)*1.1),r(t<te(1)*1.1,itr))
    else
        plot(t_a+t,r(:,itr))
    end
    xlabel('Time')
    ylabel(ylbl{itr})
    ylim(ylm(itr,:))
    x2=xlim;
    xlim([0 x2(2)])
    if itr>2
        text(t_a+te(1),ye(1,itr),'. Nose Touch','VerticalAlignment','bottom','HorizontalAlignment','left')
    end
end