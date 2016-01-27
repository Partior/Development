function mn=mnsp(P,h,PAY)

load('../constants.mat')
Cd0=0.02;

pc=p(h);
Pa=P*sqrt(pc/p(0));

r=roots([Cd0*S^2*pc^2,0,0,-2*Pa*S*pc,4*K*W0(PAY)^2]);
r=r(imag(r)==0);
mn=min(r);
