<<<<<<< HEAD
%% Plot Range based on cruise velocity
% Cruise efficiency will be based on L/D, which is turn is directly related
% to cruise speed

% Compares Wto and Speed versus max range

assumer; goals;
% Variable setup
% s=450;
% WS=Wto/s;
vcres=30; wtores=30;
[V_c,Wto]=meshgrid(linspace(150,350,vcres),linspace(12e3,22e3,wtores));


Wfix=22*(225); % Max capacity (19 passengers)
% Determine Wf and We
We=0.911*Wto.^0.947;
Wf=Wto-Wfix-We;

Wf_wto=Wf./Wto;
W1_6=1-Wf_wto/1.06;
Wr=W1_6/(0.97*0.985*1*(1)*0.985);

[clr,cdr,Cd0m]=airfoilout(Wto,p_c,Wto/WS,V_c*1.46666);
cdr=cdr*(1/0.3); % the factor makes this a little more realistic
LD=clr./cdr;
% LD=19;
sfc=0.5;

R=-log(Wr)./(sfc./(V_c.*(LD)));

figure(1); clf
contour(V_c,Wto,R/1.151,linspace(0,800,9))
c=colorbar;
c.Label.String='Range, nm';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')
title('Range @ Max Payload')

figure(2); clf
plot(V_c(1,:),LD(1,:))
ylabel('L/D')
xlabel('V_c, mph')

figure(3); clf
drg=0.5*p_c*V_c.^2.*(0.022+cdr).*Wto/WS;
contour(V_c,Wto,drg)
c3=colorbar;
c3.Label.String='Drag, lbs';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')

figure(4); clf
contour(V_c,Wto,drg.*V_c/550,10)
c4=colorbar;
c4.Label.String='Power, hp';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')

=======
%% Plot Range based on cruise velocity
% Cruise efficiency will be based on L/D, which is turn is directly related
% to cruise speed

% Compares Wto and Speed versus max range

assumer; goals;
% Variable setup
% s=450;
% WS=Wto/s;
vcres=30; wtores=30;
[V_c,Wto]=meshgrid(linspace(150,350,vcres),linspace(12e3,22e3,wtores));


Wfix=22*(225); % Max capacity (19 passengers)
% Determine Wf and We
We=0.911*Wto.^0.947;
Wf=Wto-Wfix-We;

Wf_wto=Wf./Wto;
W1_6=1-Wf_wto/1.06;
Wr=W1_6/(0.97*0.985*1*(1)*0.985);

[clr,cdr,Cd0m]=airfoilout(Wto,p_c,Wto/WS,V_c*1.46666);
cdr=cdr*(1/0.3); % the factor makes this a little more realistic
LD=clr./cdr;
% LD=19;
sfc=0.5;

R=-log(Wr)./(sfc./(V_c.*(LD)));

figure(1); clf
contour(V_c,Wto,R/1.151,linspace(0,800,9))
c=colorbar;
c.Label.String='Range, nm';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')
title('Range @ Max Payload')

figure(2); clf
plot(V_c(1,:),LD(1,:))
ylabel('L/D')
xlabel('V_c, mph')

figure(3); clf
drg=0.5*p_c*V_c.^2.*(0.022+cdr).*Wto/WS;
contour(V_c,Wto,drg)
c3=colorbar;
c3.Label.String='Drag, lbs';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')

figure(4); clf
contour(V_c,Wto,drg.*V_c/550,10)
c4=colorbar;
c4.Label.String='Power, hp';
xlabel('V_c, mph')
ylabel('W_{TO}, lbs')

>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
