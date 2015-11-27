%% Make Constants for the range equations

clear; clc

flnm='constants.mat'; 
if exist(flnm)
    delete(flnm)
end


Wfix=@(px) 225*(3+px);
We=8300; %recently modified for Propwash
Wf=1883.0;  %recently modified for Propwash
W0=@(pw) Wfix(pw)+We+Wf;
SFC=0.45;
p=@(h) 2.3769e-3*exp(-3.2e-5*h);
S=300;
AR=10;
Cd0=0.024;

e=1.78*(1-0.045*AR^0.68)-0.64; %eq 10b - http://faculty.dwc.edu/sadraey/Chapter%203.%20Drag%20Force%20and%20its%20Coefficient.pdf
K=1/(AR*e*pi);

V0=250*1.4666;

Pa=1000*550;
n=6;

hc=8; hdom=linspace(18e3,28e3,hc);
pyc=8; pdom=linspace(0,19,pyc);


RT=1e-4;

save(flnm)