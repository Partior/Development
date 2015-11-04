function dr=DR3(t,val)

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
    
cl=Wt/(0.5*p*V0^2*S);
Cd=0.02+K*cl^2;
T=0.5*p*V0^2*S*Cd;
md=-T*SFC/3600;

% dR=V dt
dr(1)=V0;
% dv, constant V
dr(2)= 0;
% dW = c * sfc * md(i-1)
dr(3)=md;
