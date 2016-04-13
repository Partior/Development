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
Lg=L(aoa,0,Vs,0);  % fuselage
if Lg>Ws
    abrake=0;
else
    abrake=32.2*muTire*(1-Lg/Ws);
end

aDrag=(Df(0,0,Vs)+Dw(0,0,Vs,ne))/(Ws/32.2);
dval(2)=-(abrake+aDrag);    % dV/dt=accel