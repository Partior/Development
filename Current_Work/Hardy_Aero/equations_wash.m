%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
%
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Pre Equations
% Lift and Drag, then calculate Cl and Cd or L/D or Cl/Cd
% Because Drag is a function of each component, and nothing to do with Cd
% of each component.
beta=@(m) sqrt(1-m.^2);

v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);

% Cruise individual prop thrust
CT=@(V,h,~,~) T(V,h,0,2)/2;
% takeoff individual prop thrust
TT=@(V,h,~,~) (T(V,h,0,8)-T(V,h,0,2))/6;

fT={CT;TT};
% How much of free stream wind is the AoA versus zero degress from prop?
% impercial formula made up
ang=@(v,h,pt) v/v2(v,fT{pt}(v,h,0,0),h,pt)*0.5;

%% Spanwise Distrubution
% Based on taper of the leading edge, determine surface area in prop wash

%  function sur(engine_number(from root),Rmax) will output surface area
%  under the prop wash of one of that specific engine

% after running sur:
s_a=[37.6990
   24.0278
   17.6206
   11.2134];

%% Lift Forces
% First, determine lift from airfoil and velcoty ratios
Lf=@(aoa,h,v) 1/2*p(h)*v.^2*Cla(aoa+Cl0)*(S)*0.2; % Approximation for Fuselage lift
Lw=@(aoa,h,v,on) ...
    1/2*p(h)*v.^2*Cla(aoa+incd)*...
    (S-2*((on-2)/2>=[0,1,2,3])*s_a)+...free stream wing lift
    1/2*p(h)*v2(v,CT(v,h,0,0),h,1).^2*Cla(ang(v,h,1)*aoa+incd)*(2*s_a(1))+... prop wash lift, cruise props
    1/2*p(h)*v2(v,TT(v,h,0,0),h,2).^2*Cla(ang(v,h,2)*aoa+incd)*...
    (2*((on-2)/2>=[1,2,3])*s_a(2:4));  %prop wash lift, takeoff props
L=@(aoa,h,v,on) Lf(aoa,h,v)+Lw(aoa,h,v,on);
    
%% Drag Forces
% For induced drag, we are taking that the lift of the fuselage is 10% of
% entire lift force, and that Wing lift is 80% of lift Force
Df=@(aoa,h,v) 1/2*p(h)*v.^2*(Cda(aoa+Cl0)+(K*Cla(aoa+Cl0).^2))*S*4; % 80*5 is length * diamter for approx surface area
Dw=@(aoa,h,v,on) ...
    1/2*p(h)*v.^2*Cda(aoa+incd)*...
    (S-2*((on-2)/2>=[0,1,2,3])*s_a)+...free stream wing drag
    1/2*p(h)*v2(v,CT(v,h,Pa,on),h,1).^2*Cda(ang(v,h,1)*aoa+incd)*(2*s_a(1))+... % prop wash drag, cruise props
    1/2*p(h)*v2(v,TT(v,h,Pa,on),h,2).^2*Cda(ang(v,h,2)*aoa+incd)*...
    (2*((on-2)/2>=[1,2,3])*s_a(2:4)); % prop wash drag, takeoff props
% Total Drag
D=@(aoa,h,v,on) Df(aoa,h,v)+Dw(aoa,h,v,on);


