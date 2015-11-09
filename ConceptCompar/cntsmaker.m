%% Make Constants for the range equations

clear; clc

flnm='constants.mat'; 
if exist(flnm)
    delete(flnm)
end


Wfix=@(px) 225*(3+px);
We=9078.7;
Wf=2654.7;
W0=@(pw) Wfix(pw)+We+Wf;
SFC=0.45;
p=@(h) 2.3769e-3*exp(-3.2e-5*h);
S=375;
AR=10;
Cd0=0.02;

K=1/(AR*0.8*pi);

V0=250*1.4666;

Pa=1000*550;

hc=8; hdom=linspace(18e3,28e3,hc);
pyc=8; pdom=linspace(0,19,pyc);


RT=1e-4;

save(flnm)