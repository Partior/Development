<<<<<<< HEAD
%% Airfoil Data
% Intake stuff, spit out airfoil conditions
function [clr,cdr,Cd0]=airfoilout(W,p,s,V)
% airfoil data
%  Calculated polar for: NACA 23012                                      
%   
%  1 1 Reynolds number fixed          Mach number fixed         
%   
%  xtrf =   1.000 (top)        1.000 (bottom)  
%  Mach =   0.300     Re =     0.000 e 6     Ncrit =   7.000
%   
%    alpha    CL        CD       CDp       CM     Top_Xtr  Bot_Xtr
a=importdata('dat.txt',' ',6);

aoa=a.data(:,1);
ind=and(aoa>-4,aoa<13.5);
cl=a.data(ind,2);
cd=a.data(ind,3);
Cd0=min(min(cd));

clr=W./(0.5*p.*(V*1.46666).^2.*s);
SF=scatteredInterpolant([cl;cl],[ones(size(cl));2*ones(size(cl))],[cd;cd]);
cdr=SF(clr,1.5*ones(size(clr)));
=======
%% Airfoil Data
% Intake stuff, spit out airfoil conditions
function [clr,cdr,Cd0]=airfoilout(W,p,s,V)
% airfoil data
%  Calculated polar for: NACA 23012                                      
%   
%  1 1 Reynolds number fixed          Mach number fixed         
%   
%  xtrf =   1.000 (top)        1.000 (bottom)  
%  Mach =   0.300     Re =     0.000 e 6     Ncrit =   7.000
%   
%    alpha    CL        CD       CDp       CM     Top_Xtr  Bot_Xtr
a=importdata('dat.txt',' ',6);

aoa=a.data(:,1);
ind=and(aoa>-4,aoa<13.5);
cl=a.data(ind,2);
cd=a.data(ind,3);
Cd0=min(min(cd));

clr=W./(0.5*p.*(V*1.46666).^2.*s);
SF=scatteredInterpolant([cl;cl],[ones(size(cl));2*ones(size(cl))],[cd;cd]);
cdr=SF(clr,1.5*ones(size(clr)));
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
