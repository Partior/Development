function dval=w_leveloff(t,val)

load('../constants.mat');
dval=zeros(size(val));

h=val(1);
Wt=val(2);
Vt=val(3);

if Vt>225*1.466
    return
end

pc=p(h);

D=1/2*pc*Vt^2*S*Cd0+K*Wt^2/(1/2*pc*Vt^2*S);

acc=((Pa*0.95*sqrt(pc/p(0)))/Vt-D)/(Wt/32.2);

dval(1)=0;
dval(2)=-D*SFC/3600;
dval(3)=acc;

