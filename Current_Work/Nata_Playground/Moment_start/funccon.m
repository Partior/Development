function [c,ceq]=funccon(X,Cla,cond)
dodd=cond(1);
ph=cond(2);
vc=cond(3);
aoa=X(1);
S=X(2);
df=X(3);
% find minimun drag given aoa and S
L=1/2*ph*vc.^2*Cla(aoa,df)*S;

c=sign(dodd)*(dodd-L);
ceq=[];