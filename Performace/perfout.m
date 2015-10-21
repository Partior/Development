%% Performance Out
% Take Parametrics and output Performance based graphs
clear; clc; figure(1); clf
parm

%% Performance by PAx
% Ground Roll distance
subplot(2,2,1)
WTO=@(px) We+Wf+225*(3+px);
a=(T0-((P*550)/VTO))/(VTO)^2;
A=@(p) 32.2*(T0/WTO(p)-mu);
B=@(p) 32.2/WTO(p)*(0.5*p_sl*(S)*(CDg-mu*CLg)+a); %SL And 10e3 ft
[x1,y1]=fplot(@(wt) 1./(2*B(wt)).*log(A(wt)./(A(wt)-B(wt)*(VTO)^2)),[0 20]);

% Range for Pax
Wf_Wto=@(wfx) Wf/(We+Wf+wfx);
W1_6=@(w) 1-Wf_Wto(w)/1.06;
Wr=@(w) W1_6(w)/(0.97*0.985*1*1*0.985);
hold on
[x2,y2]=fplot(@(Wfix) -log(Wr(225*(Wfix+3)))/(sfc/(V_c*LD)),[0 20]);
ax=plotyy(x1,y1,x2,y2);
title('Performance by Pax')
ax(1).YLabel.String='Ground Roll Distance, ft';
ax(2).YLabel.String='Range, Miles, ft';
xlabel('Passengers')

%% Rate of Climb
subplot(2,2,2)
[hx,ry]=fplot(@(h) roc(h),[0 28e3]);
plot(hx/1e3,ry*60)
title('Rate of Climb by Altitude')
xlabel('Altitude, 1000 ft')
ylabel('dh/dt, ft/min')

%% Power Avalilble
subplot(2,2,4)
vdom=[0 350]*1.466;
hold on
for h=[0,10e3,20e3,28e3]
    [x3,y3]=fplot(@(v) expow(v,h),vdom);
    plot(x3/1.466,y3)
end
plot(vdom/1.466,[2.5 2.5],'k:') %2.5g limit
title('Excess Power at Alititudes')
legend({'SL','10e3ft','20e3ft','28e3ft'})
grid on
xlabel('Velocity, mph')
ylabel('n loading, g''s')

%% V-N Diagram
subplot(2,2,3)
[vx,ny]=fplot(@(V) vn(V),vdom); %105=stall speed (ft/s)
[vx2,gy]=fplot(@(V) 1/(2*WTO(19))*(2*pi)*p_sl*S*(1.466*15)*V,vdom); %15 mph gust @ SL
plot(vx/1.466,ny)
hold on;
plot(vx2/1.466,gy+1);
legend({'Sea Level','Cruise','Gust 15 mph, sl'},'Location','southeast')
title('V-n at 19 pax')
xlabel('Velocity, mph')
ylabel('n loading, g''s')
ylim([0 3])

