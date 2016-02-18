%% Script to Display Thrust available from DEP system
% This is only from a propeller standpoint. This is not including the
% following efficiencies:

%% Setup
clear; clc

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash

%% Develop Thrust across operting regieme
%

[mmat,hmat]=meshgrid(linspace(0,0.4),linspace(0,35e3));

numopts=[0:2:6];
h=0;    % deal with sea-level for now
solopts=optimoptions('fsolve','display','none');
parfor nitr=1:length(numopts)
    for ita=1:100
        for itb=1:100
            Tmat(ita,itb,nitr)=...
                T(a(hmat(ita,itb)).*mmat(ita,itb),...
                hmat(ita,itb),...
                Pa,...
                numopts(nitr)+2);
        end
    end
end

figure(1); clf
for nitr=1:length(numopts)
    subplot(2,2,nitr)
    [~,c]=contour(mmat,hmat/1e3,Tmat(:,:,nitr),[1000:500:6000]);
    set(c,'ShowText','on','LabelSpacing',400);
    title(sprintf('Thrust, lbf, with %g Takeoff Engines',numopts(nitr)))
    xlabel('Mach')
    ylabel('Altitude, 1,000 ft')
end

%% Direct comparison

figure(2); clf
hold on
clr=['b',0,0,'r'];
for nitr=[1,length(numopts)]
    [~,c]=contour(mmat,hmat/1e3,Tmat(:,:,nitr),[1000:1000:6000]);
    set(c,'ShowText','on','LabelSpacing',1000,'LineColor',clr(nitr),'LineWidth',0.5);
end
title('Direct Comparison of Thrust, \color{red}Takeoff \color{black}vs \color{blue}Cruise')
xlabel('Mach')
ylabel('Altitude, 1,000 ft')

%% Difference by altitude
figure(3); clf
hold on
alt=[0:1e4:4e4];
for itr=1:length(alt)
    in(itr)=find(hmat(:,1)<=alt(itr),1,'last');
    plot(mmat(in(itr),:),Tmat(in(itr),:,end)-Tmat(in(itr),:,1))
end
for itr=1:length(alt)
    ldng{itr}=sprintf('%.0f ft',hmat(in(itr),1));
end
legend({ldng{1},ldng{2},ldng{3},ldng{4},ldng{5}})
title('Takeoff Minus Cruise Thrust')
xlabel('Mach')
ylabel('Thrust Difference')