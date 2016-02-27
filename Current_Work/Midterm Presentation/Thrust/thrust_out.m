%% Setup
clear; close all; clc

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash

%% Develop Thrust across operting regieme
%

[mmat,hmat]=meshgrid(linspace(0,0.3),linspace(0,40e3));

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

%% Difference by altitude
ff=figure;
clf
sz=[8 3.5];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff,'Units','inches','Position',[0.5 0.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
alt=[0,20,35]*1e3;
colorr={'r','g','b'};
for itr=1:length(alt)
    inn=find(hmat(:,1)<=alt(itr),1,'last');
    plot(mmat(inn,:),Tmat(inn,:,end),[colorr{itr},'-'])
    plot(mmat(inn,:),Tmat(inn,:,1),[colorr{itr},'-.'])
    text(mmat(inn,60),Tmat(inn,60,end),...
        sprintf('%gft',alt(itr)),'HorizontalAlignment','center','FontSize',12)
end
title('DEP and Traditional Thrust','FontSize',14)
legend({'DEP Thrust Curve';'Traditional Thrust Curve'},'FontSize',12)
xlabel('Mach','FontSize',14)
aa.FontSize=12;
ylabel('Thrust w/ same SHP, lb_f','FontSize',14)