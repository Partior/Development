%% Coefficients of Flight

CL_alpha=2*pi; % 2pi Cl per radian alpha

k=(1/(e*pi*AR));
Cl_md=sqrt(Cd0/k); % Min Drag Coefficient of Lift
Cd_md=2*Cd0;
% D_min=Cd0*0.5*p*V^2*S+k*W^2/(0.5*p*V^2*S)
% V_md=sqrt(2*W/(p*S*CL_md)); Velocity for Min drag at certain altitude
% gm_max=atand(Cl_md/Cd_md);

Cl_mp=sqrt(3)*Cl_md;  % Lift for min Power Required
Cd_mp=4*Cd0;        % Drag for min power Required
% V_mp=sqrt(2*W/(p*s))*(k/(3*CD0))^(1/4)
