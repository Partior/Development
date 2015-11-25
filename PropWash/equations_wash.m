%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
%
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Init
% run scripts to initalize variables
clear; clc
load('C:\Users\granata\Desktop\MATLAB Files\Partior\ConceptCompar\constants.mat')
n=8; % reset number of props to redo prop_T
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

%% Power Equations
% Lift and Drag, then calculate Cl and Cd or L/D or Cl/Cd
% Because Drag is a function of each component, and nothing to do with Cd
% of each component.

b=sqrt(AR*S);
chrd=S/b;
beta=@(m) sqrt(1-m.^2);

% How much of free stream wind is the AoA versus zero degress from prop?
% impercial formula made up
ang=@(v,h) v/v2(v,T(v,h),h);

% First, determine lift from airfoil and velcoty ratios
L=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cla(aoa)*((b-2*Rmax*on)*chrd)+...free stream wing lift
    1/2*p(h)*v2(v,T(v,h),h)^2*Cla(aoa*ang(v,h))*((2*Rmax*on)*chrd))+... prop wash lift
    1/2*p(h)*v^2*Cla(aoa-Cl0)*(S)*0.2; % Approximation for Fuselage lift

% For induced drag, we are taking that the lift of the fuselage is 10% of
% entire lift force, and that Wing lift is 80% of lift Force
Df=@(aoa,h,v) 1/2*p(h)*v^2*(CD0_plane(v,h)+(K*Cla(aoa-Cl0)^2)*0.1)/beta(v/a(h))*(70*5); % 80*5 is length * diamter for approx surface area
Dw=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cda(aoa)*((b-2*Rmax*on)*chrd)+...free stream wing drag
    1/2*p(h)*v2(v,T(v,h),h)^2*Cda(aoa*ang(v,h))*((2*Rmax*on)*chrd)); % prop wash drag
D=@(aoa,h,v,on) Df(aoa,h,v)+Dw(aoa,h,v,on);

% Fuel Efficiency
gmma=@(aoa,h,v,on) v./(SFC/3600*(D(aoa,h,v,on)));


