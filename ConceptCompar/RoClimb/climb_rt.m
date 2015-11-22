%% Climb Rate
% Versus Altitude

load('../constants.mat')

% Speed Versus Altitude and loading
figure(1); clf
hold on
xlabel('Altitude, 1000 ft')
ylabel('Climb Rate, ft/min')
title('Rate of Climb at V_{mp}')

for pl=[0,5,10,15,19]
    fplot(@(h) climbr(h*1e3,pl),[18 28])    % avaaliabe rarte of climb
end
plot([18 28],[100 100],'k--')
legend({'0','5','10','15','19','Service'},'Location','east')

% Plot of Vmp and P_aval
figure(2); clf
hold on
xlabel('Altitude, 1000 ft')
title('Ideal Climb Conditions')

% V_mp
[hx1,vy]=fplot(@(h) (K*W0(19)^2/(3/4*Cd0*p(h*1e3)^2*S^2))^(1/4)/1.466,[18 28]);
[hx2,Pay]=fplot(@(h) Pa*sqrt(p(h*1e3)/p(0))/550,[18 28]);   % P-avali at altitude
plotyy(hx1,vy,hx2,Pay)
gg=get(gcf,'Children');
gg(2).YLabel.String='V_{mp}, mph';
gg(1).YLabel.String='P_{Avail}, hp';
plot([18 28],[100 100],'k--')