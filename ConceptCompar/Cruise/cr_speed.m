%% Cruise Speed Analysis

clear; clc
load('../constants.mat')

% Speed at Power
figure(1); clf
subplot(2,2,1)
hold on
xlabel('Altitude, 1000 ft')
ylabel('Velocity, mph')
title('Velocity Envelope')
hdom=linspace(18,28,50);
for p_l=0.5:0.1:1
    for itr=1:50
        tmp=fenvl(Pa*p_l,hdom(itr)*1e3,19)/1.4666;
        if ~isempty(tmp)
            ye(itr,:)=tmp;
        else
            ye(itr,:)=NaN(2,1);
        end
    end
    plot(hdom,ye(:,1),'k')
    plot(hdom,ye(:,2),'r')
end
xlim([18 28])

% Speed Versus Altitude and loading
subplot(2,2,[2,4])
hold on
xlabel('Altitude, 1000 ft')
ylabel('Velocity, mph')
title('Travel Speeds, --0 pax, -Max pax')
for pl=[19,0]
    if pl==0
        ln='--';
    else
        ln='-';
    end
    fplot(@(h) mxsp(Pa,h*1e3,pl)/1.4666,[18,28],['k',ln])    % max
    fplot(@(h) mnsp(Pa,h*1e3,pl)/1.4666,[18,28],['r',ln])    % min
    fplot(@(h) (K*W0(pl)^2/(Cd0*p(h*1e3)^2*S^2))^(1/4)/1.4666,[18,28],['c',ln]) %min drag
    fplot(@(h) (K*W0(pl)^2/(3/4*Cd0*p(h*1e3)^2*S^2))^(1/4)/1.4666,[18,28],['b',ln]) %min power
    fplot(@(h) ((12*K*W0(pl)^2)/(Cd0*S^2*p(h*1e3)^2))^(1/4)/1.4666,[18,28],['g',ln])    %max eff
end
legend({'Max','Min','V_{md}','V_{mp}','Max Fuel eff'},'Location','east')


% Fuel Efficiency versus Velocity and Altitude
subplot(2,2,3)
hold on
xlabel('Velocity, mph')
ylabel('Miles per Pound of Fuel')
title('Fuel Efficiency, --0 pax, -Max pax')

for pl=[19,0]
    if pl==0
        ln='--';
    else
        ln='-';
    end
    h=[18:4:28];
    [vx,gy]=fplot(@(V) V./(SFC/3600*((Cd0*S*V^2*p(h*1e3))/2 + (2*K*W0(pl)^2)./(S*V^2*p(h*1e3)))),...
        [50 400]*1.4666);    % max min
    plot(vx/1.4666,gy/5280,ln)
end
legend({'18','22','26'},'Location','southeast')