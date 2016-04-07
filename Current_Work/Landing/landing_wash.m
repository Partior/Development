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
lift_modder

mu=0.02;    % rolling resistance
muTire=0.55;    % Braking resistance,
VLOF=fsolve(@(v) L(Clmax-incd,0,v,8)-W0(19),200,...
    optimoptions('fsolve','display','none')) % liftoff speed to which ground run goes to
save('takeoff_const.mat')
%% Approach