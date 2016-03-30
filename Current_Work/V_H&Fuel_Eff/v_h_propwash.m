%% V-H and Fuel Efficiency
% Plot number of active engines with mach and alittude for fuel efficiency,
% power reuiqed for level flight and max g's for turning.

%% Init
% run scripts to initalize variables
clear all; clc

%% Init Scripts
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

%% Domain and Constants
% Plotting a modified V-H Diagram
% Plot various number of engines at 100 and 50% power levels

resol=60;
mdom=linspace(0.15,0.5,resol);
hdom=linspace(0,35e3,resol);
[m_msh,h_msh]=meshgrid(mdom,hdom);
% started at 0.1 mach to not have to deal with wierd AoAs

% Fuel Efficiency
gmma=@(v,P) v/SFC_eq(P)/5280;

%% Figure Setup
figure(2); cla; hold on
vals=plotchoice;

pause(0.5)

pll=gcp('nocreate');
if isempty(pll)
    parpool('local')
end
%% Execution
ne=2;

taoa=NaN(resol);
pl=NaN(resol);
gm=NaN(resol);
LD=NaN(resol);
n_t=NaN(resol);

% Power Required Plots
[~,h_m]=contour(m_msh,h_msh/1e3,pl*100,[0.5 1]*100);
set(h_m,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','pl*100',...
    'LineColor','k','LineStyle','-','LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
[~,h_s]=contour(m_msh,h_msh/1e3,pl,[0.1:0.1:0.4,0.6:0.1:.9]);
set(h_s,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','pl',...
    'LineColor','k','LineStyle',':','LineWidth',0.1);
if ~vals{1}
    set([h_m,h_s],'Visible','off')
end

% Angle of Attack
[~,h_a]=contour(m_msh,h_msh/1e3,taoa,[0 2 4]);
set(h_a,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','taoa',...
    'LineColor','b','LineStyle','-','LineWidth',0.6,...
    'ShowText','on','LabelSpacing',400);
if ~vals{2}
    set([h_a],'Visible','off')
end

% Fuel Efficiency
[~,hg]=contour(m_msh,h_msh/1e3,gm,[1 1]);
set(hg,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','gm',...
    'LineColor','r','LineStyle','-','LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
[~,hgs]=contour(m_msh,h_msh/1e3,gm,[0.5:0.25:0.9]);
set(hgs,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','gm',...
    'LineColor','r','LineStyle',':','LineWidth',0.1);
if ~vals{3}
    set([hg,hgs],'Visible','off')
end

% N-turns
[~,hnp]=contour(m_msh,h_msh/1e3,n_t,[1 2 4]);
set(hnp,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','n_t',...
    'LineColor','g','LineStyle','-','LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
if ~vals{4}
    set([hnp],'Visible','off')
end

% mph lines across altitudes
[~,hs]=contour(m_msh,h_msh/1e3,m_msh.*a(h_msh),[0,250,300]*1.4666);
set(hs,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','m_msh.*a(h_msh)',...
    'LineColor','m','LineStyle','-','LineWidth',0.6);
if ~vals{5}
    set([hs],'Visible','off')
end

%% Calculate
for ita=1:resol
    parfor itb=1:resol
        hi=h_msh(ita,itb);
        vi=m_msh(ita,itb)*a(h_msh(ita,itb));
        n_t(ita,itb)=L(Clmax-incd,hi,vi,ne)/W0(19);
        if n_t(ita,itb)>1;
            tt=fzero(@(rr) L(rr,hi,vi,ne)-W0(19),[Cl0-incd Clmax-incd],optimoptions('fsolve','display','off'));
            taoa(ita,itb)=tt;
            pl(ita,itb)=D(tt,hi,vi,ne)/Tc(vi,hi);
            gm(ita,itb)=gmma(vi,pl(ita,itb)*680+100);
        end
    end
    refreshdata
    drawnow
end

%% Pretty
grid on

xlabel('Mach')
ylabel('Altitude, 1,000 ft')
t0=['V-H diagram: ',sprintf('%g Engines ',ne)];
ttl{1}=' Power Required ';
ttl{2}='\color{blue} Attack Angle ';
ttl{3}='\color{red} Fuel Efficiency ';
ttl{4}='\color{green} Stall ';
ttl{5}='\color{magenta} 250mph and 300mph ref lines ';
ttlt=[];
for ita=1:5
    if vals{ita}
        ttlt=[ttlt,ttl{ita}];
    end
end
title({t0;ttlt})
t_cruise=text(366/a(25e3),25,'Cruise');
set(t_cruise,...
    'HorizontalAlignment','center',...
    'VerticalAlignment','middle',...
    'EdgeColor','k',...
    'Color','r',...
    'FontSize',12,...
    'BackgroundColor',0.9*[1 1 1]);

perfor_out

