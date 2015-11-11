function dval=groundrun(t,val,nm,T)

load('../constants.mat')
load('takeoff_const.mat')

dval=zeros(size(val));
if val(2)>Vstall*1.15   %reached takeoff speed
    return
end
Wt=val(1);
V=val(2);
Ss=val(3);
Tt=T(V)*nm;
dval(1)=-Tt*SFC/3600; % dW
dval(2)=32.2*(Tt/Wt-mu)-32.2/Wt*1/2*p(0)*S*V^2*(Cdg-mu*Clg);
dval(3)=V;