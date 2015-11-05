function dr=DR4(t,val)

load('constants.mat')

dr=zeros(size(val));
Rt=val(1);
Vt=val(2);
Wt=val(3);
Payt=val(4);
p=val(5);

if Wt<W0(Payt)-Wf*0.5262
    return
end
    
cl=W0(Payt)/(0.5*p*V0^2*S);
Cd=0.02+K*cl^2;
T=0.5*p*V0^2*S*Cd;
P=T*V0;

% dR=V dt
dr(1)=Vt;
% dv, constant power
dr(2)= -1/3*K*P/Wt*SFC/3600;
% dW = c * sfc * md(i-1)
dr(3)=-P/Vt*SFC/3600;
