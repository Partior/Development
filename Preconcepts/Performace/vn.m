<<<<<<< HEAD
function [n]=vn(V,h)

parm
WTO=@(px) We+Wf+225*(3+px);
ph=p_sl*exp(-3.24e-05*h);
n=ph*S*CLg/(2*WTO(19))*V.^2;

n(n>2.5)=2.5;
=======
function [n]=vn(V,h)

parm
WTO=@(px) We+Wf+225*(3+px);
ph=p_sl*exp(-3.24e-05*h);
n=ph*S*CLg/(2*WTO(19))*V.^2;

n(n>2.5)=2.5;
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
n(n<1)=0;