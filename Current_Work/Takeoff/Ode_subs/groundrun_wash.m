function dval=groundrun_wash(~,val,n)

persistent mu SFC_eq Pa L T Df Dw %#ok<PSET>
if isempty(mu)
    load('takeoff_const.mat')
end

dval=zeros(size(val));

Wt=val(1);
Vt=val(2);

% formulation of dV/dt
Lg=L(0,0,Vt,n);
Dr=max(0,mu*(Wt-Lg)); % rolling resistance
Tt=T(Vt,0,n);
Dg=Df(0,0,Vt)+Dw(0,0,Vt,n)*0.2880; % air drag resistance
% using eq 19A from  http://www.dept.aoe.vt.edu/~lutze/AOE3104/takeoff&landing.pdf


dval(1)=-SFC_eq(Pa/550); % dW
dval(2)=32.2/Wt*(Tt-Dg-Dr); % dv/dt
dval(3)=Vt; %ds/dt