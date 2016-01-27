clear; clc
load('../Constants.mat','W0','K','Cd0','S','p')

flnm='takeoff_const.mat'; 
if exist(flnm)
    delete(flnm)
end

Clg=1.6;
mu=0.04;
Cdg=Cd0+K*Clg^2;
muTire=0.35;

Vstall=sqrt(2*W0(19)/(S*p(0)*(Clg+0.1))); % used later

clear W0 K Cd0 S p

save(flnm)