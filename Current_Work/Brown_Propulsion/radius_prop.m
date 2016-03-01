%% Radius of the Propeller Blades
% Calculation of the maximum radius of the prop blade for efficiency;

Mt=@(v,h,r) sqrt((v/(a(h)))^2+((rpm*2*pi/60)*r/a(h))^2);
Rmax=fsolve(@(r) 0.85-Mt(366,25e3,r),2,optimoptions('fsolve','display','off'));
Rmax=min(Rmax,(b-cab_diam)/(2*n));  % Radius
% 
% Rmax=[Rmax;Rmax*0.75];
% A=Rmax.^2*pi;

%% After 29 FEB
% Data from Brown with the following information:

% 5 bladed propeller, 11.64 foot pitch
Rmax=[1.19422336216550;0.982995962258428]*3.2808399;
A=Rmax.^2*pi;