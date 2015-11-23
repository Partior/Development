%% Drag Considerations
% With the wing experiencing different velocity to the airplane, drag and
% lift forces for each now become seperate and unique

%% Fuselage
% http://faculty.dwc.edu/sadraey/Chapter%203.%20Drag%20Force%20and%20its%20Coefficient.pdf
RE=@(v,h,x) p(h)*v*(x)/visc(h); % x is length, fuselage taken to be 60 ft
% Turbulent
Cft=@(v,h,x) 0.455./(log10(RE(v,h,x))).^2.58;
% Laminar
Cfl=@(v,h,x) 1.327./sqrt(RE(v,h,x));

% using transition between 2e5 and 2e6
trans=@(v,h) fsolve(@(x) 2e5-RE(v,h,x),30,optimoptions('fsolve','Display','off'));

% ld is length to diameter ratio
f_LD=@(ld) 1+60/ld^3+0.0025*ld;

% function of mach number
f_M=@(m) 1-0.08*m^1.45; 

Cf=@(v,h,l) (integral(@(x) Cfl(v,h,x),0,trans(v,h))+...
    integral(@(x) Cft(v,h,x),trans(v,h),l))/l;

% Wetted Area and Wing Surface Area
S_wet=4.5*S; % from Dr. Raj Lecture 4
S_wet_f=S_wet-2*S; % minus both sides of the wings

CD0_fuse=@(v,h) Cf(v,h,80)*f_LD(80/5)*f_M(v/a(h))*(S_wet_f/S);

%% Total minus Wing
% again from above article, assuming fuselage drag creates 28% of entire
% airplane drag, and wings create 23% of airplane drag:
CD0_plane=@(v,h) CD0_fuse(v,h)*(1/.30)*(1-.23);