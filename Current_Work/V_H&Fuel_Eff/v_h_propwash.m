%% V-H and Fuel Efficiency
% Plot number of active engines with mach and alittude for fuel efficiency,
% power reuiqed for level flight and max g's for turning.

%% Init
% run scripts to initalize variables
clear;

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

resol=100;
[m_msh,h_msh]=meshgrid(linspace(0.1,0.5,resol),linspace(0,50e3,resol));
% started at 0.1 mach to not have to deal with wierd AoAs

% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h,Pa,on));

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
[~,hg]=contour(m_msh,h_msh/1e3,gm,[1 1.5 2]);
set(hg,'XDataSource','m_msh','YDataSource','h_msh/1e3','ZDataSource','gm',...
    'LineColor','r','LineStyle','-','LineWidth',1.5,...
    'ShowText','on','LabelSpacing',400);
% [1.1:0.1:1.4 1.6:0.1:1.9]
[~,hgs]=contour(m_msh,h_msh/1e3,gm,[1.25 1.75]);
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
        n_t(ita,itb)=L(12-incd,hi,vi,ne)/W0(19);
        if n_t(ita,itb)<0.9;
            continue
        end
        taoa(ita,itb)=fsolve(@(rr) L(rr,hi,vi,ne)-W0(19),0,optimoptions('fsolve','display','off'));
        pl(ita,itb)=plvl(taoa(ita,itb),hi,vi,ne);
        if pl(ita,itb)>1;
            continue
        end
        gm(ita,itb)=gmma(vi,pl(ita,itb)*340*2);
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
ttl{4}='\color{green} N-Manuevers ';
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

%% Prettier
perfor_out

p2t=nextpow2(100/resol);
m_msh2=interp2(m_msh,p2t);
h_msh2=interp2(h_msh,p2t);
n_t=interp2(m_msh,h_msh,n_t,m_msh2,h_msh2,'linear');
taoa=interp2(m_msh,h_msh,taoa,m_msh2,h_msh2,'linear');
pl=interp2(m_msh,h_msh,pl,m_msh2,h_msh2,'linear');
gm=interp2(m_msh,h_msh,gm,m_msh2,h_msh2,'linear');

m_msh=m_msh2; h_msh=h_msh2;
refreshdata
drawnow
