function dval=w_climb(t,val)

load('../constants.mat');
dval=zeros(size(val));

h=val(1);
Wt=val(2);

if h>24000
    return
end

pc=p(h);

Vmp=(K*Wt^2/(1/2*pc^2*S^2*Cd0))^(1/4);
T=1/2*pc*Vmp^2*S*Cd0+K*Wt^2/(1/2*pc*Vmp^2*S);

dval(2)=-T*SFC/3600;
dval(1)=((Pa*0.8*sqrt(pc/p(0)))-T*Vmp)/Wt;

