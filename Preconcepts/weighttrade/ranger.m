%% Adjusting Payload (Wfix) and seeing Range results
% Independatn variables: Wfix and W_to. 
%   We and Wf will be calculated from there. Assume flying at LD=20

assumer; goals;
% Variable setup
wfres=30; wtores=30;
[Wfix,Wto]=meshgrid(linspace(1250,6000,wfres),linspace(0.5e4,2e4,wtores));

% Determine Wf and We
We=0.911*Wto.^0.947;
Wf=Wto-Wfix-We;

Wf_wto=Wf./Wto;
W1_6=1-Wf_wto/1.06;
Wr=W1_6/(0.97*0.985*1*(1)*0.985);

V_c=265;
[clr,cdr,Cd0m]=airfoilout(Wto,p_c,Wto/WS,V_c*1.46666);
LD=clr./(Cd0m+clr.^2*K)*0.7; % 0.7 factor in there to make more realistic (3d effects)
% LD=19;
sfc=0.5;

R=-log(Wr)./(sfc./(V_c.*(LD)));

contour(Wfix/225-3,Wto,R,linspace(400,2500,15));
title('V_c=265,LD=adj')
xlabel('Passengers, @ 225 lbs each')
ylabel('Wto')
c=colorbar;
c.Label.String='Max Range';