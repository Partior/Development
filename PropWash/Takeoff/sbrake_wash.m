function dval=sbrake(t,val,ne)

load('takeoff_const.mat')

dval=zeros(size(val));

Ws=val(1);
Vs=val(2);
Ss=val(3);

if Vs<1
    return
end

dval(1)=0; %dW=0 (no fuel)
dval(3)=Vs; % ds/dt=V

h=0; aoa=0;
Lg=1/2*p(h)*Vs^2*Cla(aoa)*S+...  % Wings, no accelerated flow
    1/2*p(h)*Vs^2*Cla(aoa-Cl0)*(S)*0.2;  % fuselage
if Lg>Ws
    abrake=0;
else
    abrake=32.2*muTire*(1-Lg/Ws);
end

aDrag=D(0,0,Vs,ne)/(Ws/32.2);
dval(2)=-(abrake+aDrag);    % dV/dt=accel