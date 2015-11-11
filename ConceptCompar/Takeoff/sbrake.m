function dval=sbrake(t,val)

load('../constants.mat')
load('takeoff_const.mat')

dval=zeros(size(val));

Ws=val(1);
Vs=val(2);
Ss=val(3);


if Vs<=0
    return
end
dval(1)=0; %dW=0 (no fuel)
dval(3)=Vs; % ds/dt=V

L=0.5*2.3e-3*Vs^2*S*Clg;
if L>Ws
    abrake=0;
else
    abrake=32.2*muTire*(1-L/Ws);
end
aDrag=0.5*p(0)*Vs^2*S*Cdg/(Ws/32.2);
dval(2)=-(abrake+aDrag);    % dV/dt=accel