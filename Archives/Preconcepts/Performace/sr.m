
function [srout]=sr(h,V)

parm
ph=p_sl*exp(-3.8329e-05*h);
WTO=We+Wf+225*(3+19);
K=1/(e*pi*AR);
Cd0=0.022; %guess
nup=0.9; %efficiency
Dr=Cd0*0.5*ph*V.^2.*(WTO/S)+K*WTO/S./(0.5*ph*V.^2);
Pr=Dr*V;

srout=nup*V/(0.5*Pr);