%% Cruise Speed Analysis


load('../constants.mat')
P=1000*550;

% Speed Versus Altitude and loading
figure(1); clf
hold on
xlabel('Altitude, 1000 ft')
ylabel('Velocity, mph')
title('Travel Speeds, -0 pax, --Max pax')

for pl=[0,19]
    if pl==0
        ln='-';
    else
        ln='--';
    end
    fplot(@(h) mxsp(P,h*1e3,pl)/1.4666,[18,28],['k',ln])    % max
    fplot(@(h) mnsp(P,h*1e3,pl)/1.4666,[18,28],['r',ln])    % min
    fplot(@(h) (K*W0(pl)^2/(Cd0*p(h*1e3)^2*S^2))^(1/4)/1.4666,[18,28],['c',ln]) %min drag
    fplot(@(h) (K*W0(pl)^2/(3/4*Cd0*p(h*1e3)^2*S^2))^(1/4)/1.4666,[18,28],['b',ln]) %min power
    fplot(@(h) ((12*K*W0(pl)^2)/(Cd0*S^2*p(h*1e3)^2))^(1/4)/1.4666,[18,28],['g',ln])    %max eff
end
legend({'Max','Min','V_{md}','V_{mp}','Max Fuel eff'},'Location','eastoutside')


% Fuel Efficiency versus Velocity and Altitude
figure(2); clf
hold on
xlabel('Velocity, mph')
ylabel('Miles per Pound of Fuel')
title('Fuel Efficiency, -0 pax, --Max pax')

for pl=[0,19]
    if pl==0
        ln='-';
    else
        ln='--';
    end
    for h=[18:4:28]
        [vx,gy]=fplot(@(V) V/(SFC/3600*((Cd0*S*V^2*p(h*1e3))/2 + (2*K*W0(pl)^2)/(S*V^2*p(h*1e3)))),[50 400]*1.4666);    % max min
        plot(vx/1.4666,gy/5280,ln)
    end
end
legend({'18','22','26'},'Location','southeast')