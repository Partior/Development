function dval=w_climb(t,val,h_c)

load('../constants.mat');

dval=zeros(size(val));

h=val(1);
Wt=val(2);

if h>h_c
    return
end

pc=p(h);

Vmp=(K*Wt^2/(1/2*pc^2*S^2*Cd0))^(1/4);
T=1/2*pc*Vmp^2*S*Cd0+K*Wt^2/(1/2*pc*Vmp^2*S);

dval(2)=-T*SFC/3600;    % dW=mdot
dval(1)=((Pa*0.95*sqrt(pc/p(0)))-T*Vmp)/Wt; %dh/dt=P_ex/W-1/g(dv/dt)

%iterate a couple of times for accuracy, I'm lazy
for itr=1:5
dvdt=(K*(Wt+dval(2))^2/(1/2*p(h+dval(1))^2*S^2*Cd0))^(1/4)-Vmp;
dval(1)=dval(1)-1/(32.2)*dvdt;
end

