%% Radius of the Propeller Blades
% Calculation of the maximum radius of the prop blade for efficiency;

Mt=@(v,h,r) sqrt((v/(a(h)))^2+((rpm*2*pi/60)*r/a(h))^2);
Rmax=fsolve(@(r) 0.85-Mt(366,25e3,r),2,optimoptions('fsolve','display','off'));
Rmax=min(Rmax,(b-cab_diam)/(2*n));  % Radius
A=Rmax^2*pi;

Rmax=[Rmax;Rmax*0.75];
A=Rmax.^2*pi;