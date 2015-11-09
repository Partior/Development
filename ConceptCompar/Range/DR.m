function dr=DR(~,val)
load('../constants.mat')
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
mdt=T*SFC/3600;

% dR=V dt
dr(1)=Vt;
% dW=T sfc dt
dr(3)=-mdt;
% Velocity
dr(2)=-4*K*Wt*-mdt/...
    (p*S*Vt^2*(Vt*0.02*p*S-4*K*Wt^2/(p*S*Vt^3)));

end