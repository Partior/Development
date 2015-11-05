<<<<<<< HEAD
%% Power for takeoff

T0=@(p) 0.25*(p./n.*d).^(2/3);
T0t=@(p) T0(p).*n;
a=@(p) ((p/VTO)-T0t(p))/(VTO)^2;
A=@(p) 32.2*(T0t(p)/15000-0.04);
mu=0.04; % Firm Turf
Cdg=0.0527; %Ground roll drag
CLg=1.7; % max ground lift
Wto=16000; % Weight at takeoff
WS=35; % wingloading
B=@(p) 32.2/Wto*(0.5*p_sl*(Wto/WS)*(Cdg-mu*CLg)+a(p));
s=@(p) 1./(2*B(p)).*log(A(p)./(A(p)-B(p)*(VTO)^2));

=======
%% Power for takeoff

T0=@(p) 0.25*(p./n.*d).^(2/3);
T0t=@(p) T0(p).*n;
a=@(p) ((p/VTO)-T0t(p))/(VTO)^2;
A=@(p) 32.2*(T0t(p)/15000-0.04);
mu=0.04; % Firm Turf
Cdg=0.0527; %Ground roll drag
CLg=1.7; % max ground lift
Wto=16000; % Weight at takeoff
WS=35; % wingloading
B=@(p) 32.2/Wto*(0.5*p_sl*(Wto/WS)*(Cdg-mu*CLg)+a(p));
s=@(p) 1./(2*B(p)).*log(A(p)./(A(p)-B(p)*(VTO)^2));

>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
P_TO=fsolve(@(p) s(p)-2000,600*550);