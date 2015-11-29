%% V-H and Fuel Efficiency
% Plot number of active engines with mach and alittude for fuel efficiency,
% power reuiqed for level flight and max g's for turning.

%% Init
% run scripts to initalize variables
clear; clc
load('C:\Users\granata\Desktop\MATLAB Files\Partior\ConceptCompar\constants.mat')

AR=15;
S=200;
n=8;

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

%% Domain and Constants
% Plotting a modified V-H Diagram
% Plot various number of engines at 100 and 50% power levels

resol=40;
mdom=[linspace(0.1,0.25,10),linspace(0.25,0.41,20),linspace(0.41,0.5,10)];
[m_msh,h_msh]=meshgrid(mdom,linspace(0,45e3,resol));

% started at 0.1 mach to not have to deal with wierd AoAs
% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h,Pa/n)*on);

% Fuel Efficiency
gmma=@(aoa,h,v,on) v./(SFC/3600*(D(aoa,h,v,on)));

%% Figure Setup
figure(2); clf; hold on
vals=plotchoice;

taoa=zeros(resol);
pl=zeros(resol);
gm=zeros(resol);
LD=zeros(resol);
n_t=zeros(resol);

pll=gcp('nocreate');
if isempty(pll)
    parpool('local')
end

%% Execution
wb=waitbar(0,'Waiting');
for ne=[6]
    %     subplot(1,2,(ne-4)/2);
    cla; hold on
    for ita=1:resol
        waitbar(ita/resol,wb,sprintf('Waiting, %g',ne))
        parfor itb=1:resol
            hi=h_msh(ita,itb);
            vi=m_msh(ita,itb)*a(h_msh(ita,itb));
            taoa(ita,itb)=fsolve(@(rr) L(rr,hi,vi,ne)-W0(19),0,optimoptions('fsolve','display','off'));
            pl(ita,itb)=plvl(taoa(ita,itb),hi,vi,ne);
            gm(ita,itb)=gmma(taoa(ita,itb),hi,vi,ne);
            LD(ita,itb)=L(taoa(ita,itb),hi,vi,ne)/D(taoa(ita,itb),hi,vi,ne);
            n_t(ita,itb)=L(13-incd,hi,vi,ne)/W0(19);
        end
    end
    
    pl_plot=reshape(pl(imag(pl)==0),size(pl));
    
    if vals{1}
        % Power Required Plots
        [~,h_m]=contour(m_msh,h_msh/1e3,pl_plot,[0.5 1]);
        set(h_m,'LineColor','k','LineStyle','-','LineWidth',1.5,...
            'ShowText','on','LabelSpacing',400);
        [~,h_s]=contour(m_msh,h_msh/1e3,pl_plot,[0.1:0.1:0.4,0.6:0.1:.9]);
        set(h_s,'LineColor','k','LineStyle',':','LineWidth',0.1);
    end
    
    if vals{2}
        % Angle of Attack
        [~,h_a]=contour(m_msh,h_msh/1e3,taoa,-1:4);
        set(h_a,'LineColor','b','LineStyle','-','LineWidth',0.6,...
            'ShowText','on','LabelSpacing',400);
    end
    
    if vals{3}
        % Fuel Efficiency
        [~,hg]=contour(m_msh,h_msh/1e3,gm/5280,[0.5 1]);
        set(hg,'LineColor','r','LineStyle','-','LineWidth',1.5,...
            'ShowText','on','LabelSpacing',400);
        [~,hgs]=contour(m_msh,h_msh/1e3,gm/5280,[0.6:0.1:0.9 1.1:0.1:1.4]);
        set(hgs,'LineColor','r','LineStyle',':','LineWidth',0.1);
    end
    
    if vals{4}
        % L/D Lines
        [~,hLD]=contour(m_msh,h_msh/1e3,LD,[16:4:28]);
        set(hLD,'LineColor','m','LineStyle','--','LineWidth',0.6,...
            'ShowText','on','LabelSpacing',400);
    end
    
    if vals{5}
        % N-turns
        [~,hnp]=contour(m_msh,h_msh/1e3,n_t,[0.5 1 2 4]);
        set(hnp,'LineColor','g','LineStyle','-','LineWidth',1.5,...
            'ShowText','on','LabelSpacing',400);
        [~,hns]=contour(m_msh,h_msh/1e3,n_t,...
            [0.75 1.25:0.25:1.75 2.25:0.25:3.75]);
        set(hns,'LineColor','g','LineStyle',':','LineWidth',0.1);
    end
    
    if vals{6}
        % mph lines across altitudes
        [~,hs]=contour(m_msh,h_msh/1e3,m_msh.*a(h_msh),[150,250,300]*1.4666);
        set(hs,'LineColor','c','LineStyle','-','LineWidth',0.6);
    end
    
    grid on
    
    xlabel('Mach')
    ylabel('Altitude, 1,000 ft')
    title(sprintf('%g Engines',ne))
    
end
close(wb)