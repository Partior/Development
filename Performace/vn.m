function [n]=vn(V)

parm
WTO=@(px) We+Wf+225*(3+px);
n=[p_sl,p_c]*S*CLg/(2*WTO(19))*V^2;

n(n>2.5)=2.5;
n(n<1)=0;