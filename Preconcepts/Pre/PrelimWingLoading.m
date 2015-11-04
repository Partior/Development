<<<<<<< HEAD
AR=12; %ALTERATION, usted to be 7
Cd0=0.02;
e=0.75;
opts=optimoptions('fsolve','Display','off');
Clm=fsolve(@(x) 1/LD-(Cd0+1/(pi*AR*e)*(x^2))/x,1.5,opts); % approximated from L/D max and Cd0
p=8.9068e-4; %rho at 30,000 ft
W=Wto; %from Wto_Approx
TW=0.45; % Assumed T/W ratio from Turbojet approximations
    %%ALTERATION, used to 0.35


rng=@(x) 1.07/sfc(1)*(x/p).^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/W);
Sto=@(x) 20.9*(x/(Clm*TW))+69.6*sqrt((x/(Clm*TW))*TW);
Sl=@(x) 79.4*(x/(Clm))+50/tand(3); % Assume 3 degree descent pattern

[x1,y1]=fplot(@(x) Sto(x),[30,80]);
[x2,y2]=fplot(@(x) rng(x),[30,80]);
h=plotyy(x1,y1,x2,y2*Wf_Wto*Wto);
title('Wing Loading Versus Flight Parameters')
xlabel('Wing Loading, W/S lb/ft^2')
ylabel(h(1),'Takeoff Distance, S_{TO} ft');
ylabel(h(2),'Total Range, mi');
y1tick=[1:5]*1e3;
y2tick=[1:6]*1e3;
set(h(1),{'YLim','YTick','YTickLabel'},...
    {[min(y1tick) max(y1tick)],y1tick,y1tick})
set(h(2),{'YLim','YTick','YTickLabel'},...
=======
AR=12; %ALTERATION, usted to be 7
Cd0=0.02;
e=0.75;
opts=optimoptions('fsolve','Display','off');
Clm=fsolve(@(x) 1/LD-(Cd0+1/(pi*AR*e)*(x^2))/x,1.5,opts); % approximated from L/D max and Cd0
p=8.9068e-4; %rho at 30,000 ft
W=Wto; %from Wto_Approx
TW=0.45; % Assumed T/W ratio from Turbojet approximations
    %%ALTERATION, used to 0.35


rng=@(x) 1.07/sfc(1)*(x/p).^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/W);
Sto=@(x) 20.9*(x/(Clm*TW))+69.6*sqrt((x/(Clm*TW))*TW);
Sl=@(x) 79.4*(x/(Clm))+50/tand(3); % Assume 3 degree descent pattern

[x1,y1]=fplot(@(x) Sto(x),[30,80]);
[x2,y2]=fplot(@(x) rng(x),[30,80]);
h=plotyy(x1,y1,x2,y2*Wf_Wto*Wto);
title('Wing Loading Versus Flight Parameters')
xlabel('Wing Loading, W/S lb/ft^2')
ylabel(h(1),'Takeoff Distance, S_{TO} ft');
ylabel(h(2),'Total Range, mi');
y1tick=[1:5]*1e3;
y2tick=[1:6]*1e3;
set(h(1),{'YLim','YTick','YTickLabel'},...
    {[min(y1tick) max(y1tick)],y1tick,y1tick})
set(h(2),{'YLim','YTick','YTickLabel'},...
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
    {[min(y2tick) max(y2tick)],y2tick,y2tick})