%% Performance Out
% Take Parametrics and output Performance based graphs
clear; clc; figure(4); clf
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
ax(2).YLabel.String='Range, Miles';
xlabel('Passengers')

%% Rate of Climb
subplot(2,2,2)
[hx,ry]=fplot(@(h) roc(h),[0 30e3]);
plot(hx/1e3,ry*60)
title('Rate of Climb by Altitude')
xlabel('Altitude, 1000 ft')
ylabel('dh/dt, ft/min')

%% V-N Diagram
subplot(2,2,3)
hold on
vdom=linspace(50,300)*1.466;
% for h=[0 20e3];
% [vx,ny]=fplot(@(V) vn(V,h),vdom); %105=stall speed (ft/s)
%  plot(vx/1.466,ny)
% end
% [vx2,gy]=fplot(@(V) 1/(2*WTO(19))*(2*pi)*p_sl*S*(1.466*15)*V,vdom); %15 mph gust @ S
% hold on;
% plot(vx2/1.466,gy+1);
% legend({'Sea Level','Cruise','Gust 15 mph, sl'},'Location','southeast')
% title('V-n at 19 pax')
% xlabel('Velocity, mph')
% ylabel('n loading, g''s')
% ylim([0 3])


%% Power Avalilble
subplot(2,2,3:4)
hold on
hdom=[0,10e3,20e3,28e3];
plt=[];
for h=1:length(hdom)
    y3=expow(vdom,hdom(h));
    ny=vn(vdom,hdom(h)); %105=stall speed (ft/s)
    plot(vdom/1.466,y3,'-.')
    plot(vdom/1.466,ny,'-.')
    plt(h)=plot(vdom/1.4666,min(y3,ny));
end
plot([vdom(1),vdom(end)]/1.466,[2.5,1;2.5,1],'k:') %2.5g limit
title('Excess Power at Alititudes')
legend(plt,{'SL','10e3ft','20e3ft','28e3ft'})
% grid on
ylim([0 3])
xlim([50 300])
xlabel('Velocity, mph')
ylabel('n loading, g''s')
