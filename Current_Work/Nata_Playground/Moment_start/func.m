function D=func(X,Cda,cond)
ph=cond(2);
vc=cond(3);
aoa=X(1);
S=X(2);
% find minimun drag given aoa and S
D=1/2*ph*vc.^2*Cda(aoa)*S;