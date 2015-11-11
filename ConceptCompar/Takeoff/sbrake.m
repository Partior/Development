function dval=sbrake(t,val)

load('../constants.mat')
load('takeoff_const.mat')

dval=zeros(size(val));
Vs=val(1);
Ss=val(2);
Ws=val(3);

if Vs<=0
    return
end
dval(2)=Vs;
dval(3)=0;

L=0.5*2.3e-3*Vs^2*S*Clg;
if L>Ws
    abrake=0;
else
    abrake=32.2*muTire*(1-L/Ws);
end
aDrag=0.5*p(0)*Vs^2*S*Cdg/(Ws/32.2);
dval(1)=-(abrake+aDrag);