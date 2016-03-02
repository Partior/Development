function dval=groundrun_wash(~,val,nm,ne)

load('takeoff_const.mat')

dval=zeros(size(val));
if val(2)>VLOF   %reached takeoff speed
    return
end

Wt=val(1);
Vt=val(2);

% formulation of dV/dt
Lg=L(0,0,Vt,ne);
Dr=max(0,mu*(Wt-Lg)); % rolling resistance
Tt=T(Vt,0,0,nm*ne);
Dg=D(0,0,Vt,ne); % air drag resistance
dval(2)=32.2/Wt*(Tt-Dg-Dr);

dval(1)=-SFC_eq(Pa/550); % dW
dval(3)=Vt;