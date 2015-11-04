function dr=DR2(t,val)

load('constants.mat')
dr=zeros(size(val));
Rt=val(1);
Vt=val(2);
Wt=val(3);
Payt=val(4);
p=val(5);

if Wt<W0(Payt)-Wf*0.8
    return
end

cl=W0(Payt)/(0.5*p*V0^2*S);
Cd=0.02+K*cl^2;

% dR=V dt
dr(1)=Vt;
% dW = md dt
% md = T SFC
% T = D
D = 0.5*p*Vt^2*S*Cd;
md=D*SFC/3600;
dr(3)=-md;
% dV = dW
dr(2)= 1/2*sqrt(2/(Wt*cl*p*S))*dr(3);
