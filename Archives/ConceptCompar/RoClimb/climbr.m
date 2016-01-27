function roc=climbr(h,pl)

load('../constants.mat')

Vmp=(K*W0(pl)^2/(3/4*Cd0*p(h)^2*S^2))^(1/4);
Cl=W0(pl)/(0.5*p(h)*Vmp^2*S);
cd=Cd0+K*Cl^2;
Pr_mp=0.5*p(h)*Vmp^3*S*(cd);

roc=(Pa*sqrt(p(h)/p(0))-Pr_mp)/W0(pl)*60;
