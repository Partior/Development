%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
%
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Power Equations
% Lift and Drag, then calculate Cl and Cd or L/D or Cl/Cd
% Because Drag is a function of each component, and nothing to do with Cd
% of each component.

chrd=S/b;
beta=@(m) sqrt(1-m.^2);

% How much of free stream wind is the AoA versus zero degress from prop?
% impercial formula made up
ang=@(v,h) v/v2(v,T(v,h,Pa/n),h)*0.5;

% ANGLE OF INCIDENCE
% incd=6;     % incedence angle of wing strucutre
Cl0=-1.1793;    % Zero Lift AoA

% First, determine lift from airfoil and velcoty ratios
Lf=@(aoa,h,v) 1/2*p(h)*v^2*Cla(aoa+Cl0)*(S)*0.2; % Approximation for Fuselage lift
Lw=@(aoa,h,v,on) 1/2*p(h)*v^2*Cla(aoa+incd)*((b-2*Rmax*on)*chrd)+...free stream wing lift
    1/2*p(h)*v2(v,T(v,h,Pa/n),h)^2*Cla(incd)*((2*Rmax*on)*chrd); % prop wash lift
L=@(aoa,h,v,on) Lf(aoa,h,v)+Lw(aoa,h,v,on);
    

% For induced drag, we are taking that the lift of the fuselage is 10% of
% entire lift force, and that Wing lift is 80% of lift Force
Df=@(aoa,h,v) 1/2*p(h)*v^2*(CD0_plane(v,h)+(K*Cla(aoa+Cl0).^2))*S*0.8; % 80*5 is length * diamter for approx surface area
Dw=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cda(aoa+incd)*((b-2*Rmax*on)*chrd)+...free stream wing drag
    1/2*p(h)*v2(v,T(v,h,Pa/n),h)^2*Cda(incd)*((2*Rmax*on)*chrd)); % prop wash drag
% Total Drag
D=@(aoa,h,v,on) Df(aoa,h,v)+Dw(aoa,h,v,on);


