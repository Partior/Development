<<<<<<< HEAD
function [dhdt]=roc(h)

parm
ph=p_sl*exp(-3.24e-05*h);
Pa=P*550*sqrt(ph/p_sl);
WTO=We+Wf+225*(3+19);
K=1/(e*pi*AR);
Cd0=0.022; %guess
V=sqrt(2*WTO/(S*ph))*(K/(3*Cd0))^(1/4); %min power vel
q=0.5*ph*V^2;
dvdt=0; % no acceleration
n=1; % no stressing
g=32.2;
=======
function [dhdt]=roc(h)

parm
ph=p_sl*exp(-3.24e-05*h);
Pa=P*550*sqrt(ph/p_sl);
WTO=We+Wf+225*(3+19);
K=1/(e*pi*AR);
Cd0=0.022; %guess
V=sqrt(2*WTO/(S*ph))*(K/(3*Cd0))^(1/4); %min power vel
q=0.5*ph*V^2;
dvdt=0; % no acceleration
n=1; % no stressing
g=32.2;
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
dhdt=-V*((K*WTO*n^2)/(S*q)-Pa/V/WTO+dvdt/g+(Cd0*S*q)/WTO);