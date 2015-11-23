%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
%
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Init
% run scripts to initalize variables
clear; clc
load('../ConceptCompar/constants.mat')
n=12; % reset number of props to redo prop_T
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

%% Power Equations
% Lift and Drag, then calculate Cl and Cd or L/D or Cl/Cd
% Because Drag is a function of each component, and nothing to do with Cd
% of each component.

b=sqrt(AR*S);
chrd=S/b;
beta=@(m) sqrt(1-m.^2);

% How much of free stream wind is the AoA versus zero degress from prop?
% impercial formula made up
ang=@(v,h) v/v2(v,T(v,h),h);

% First, determine lift from airfoil and velcoty ratios
L=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cla(aoa)*((b-2*Rmax*on)*chrd)+...free stream wing lift
    1/2*p(h)*v2(v,T(v,h),h)^2*Cla(aoa*ang(v,h))*((2*Rmax*on)*chrd))+... prop wash lift
    1/2*p(h)*v^2*Cla(aoa)*(S)*0.2; % Approximation for Fuselage lift

% For induced drag, we are taking that the lift of the fuselage is 10% of
% entire lift force, and that Wing lift is 80% of lift Force
Df=@(aoa,h,v) 1/2*p(h)*v^2*(CD0_plane(v,h)+(K*Cla(aoa)^2)*0.1)/beta(v/a(h))*(70*5); % 80*5 is length * diamter for approx surface area
Dw=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cda(aoa)*((b-2*Rmax*on)*chrd)+...free stream wing drag
    1/2*p(h)*v2(v,T(v,h),h)^2*Cda(aoa*ang(v,h))*((2*Rmax*on)*chrd)); % prop wash drag
D=@(aoa,h,v,on) Df(aoa,h,v)+Dw(aoa,h,v,on);

% Fuel Efficiency
gmma=@(aoa,h,v,on) v./(SFC/3600*(D(aoa,h,v,on)));

%% Domain and Constants
% Plotting a modified V-H Diagram
% Plot various number of engines at 100 and 75% power levels
% Stall line for each

resol=20;
[m_msh,h_msh]=meshgrid(linspace(0.1,0.5,resol),linspace(0,40e3,resol));
taoa=zeros(resol);
pl=zeros(resol);
% started at 0.1 mach to not have to deal with wierd AoAs

% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h)*on/n);
pl=zeros(resol);
gm=zeros(resol);

figure(2); clf; hold on

prim=[0.5 1];
supp=[0.1:0.1:0.4,0.6:0.1:.9];
clr=['k','b','c','g','y','r'];

pll=gcp('nocreate');
if isempty(pll)
    parpool('local')
end

%% Execution
wb=waitbar(0,'Waiting');
for ne=[8,10]
    subplot(1,2,(ne-6)/2); hold on
    for ita=1:resol
        waitbar(ita/40,wb,sprintf('Waiting, %g',ne))
        parfor itb=1:resol
            hi=h_msh(ita,itb);
            vi=m_msh(ita,itb)*a(h_msh(ita,itb));
            taoa(ita,itb)=fsolve(@(rr) L(rr,hi,vi,ne)-W0(19),0,optimoptions('fsolve','display','off'));
            if isnan(taoa(ita,itb))
                pl(ita,itb)=NaN;
                gm(ita,itb)=NaN;
            else
                pl(ita,itb)=plvl(taoa(ita,itb),hi,vi,ne);
                gm(ita,itb)=gmma(taoa(ita,itb),hi,vi,ne);
            end
        end
    end
    
    pl_plot=reshape(pl(imag(pl)==0),size(pl));
    
    cli=clr(ne/2);
    [~,h_m]=contour(m_msh,h_msh/1e3,pl_plot,prim);
    set(h_m,'LineColor','k','LineStyle','-','LineWidth',1.5,...
        'ShowText','on','LabelSpacing',400);
    [~,h_s]=contour(m_msh,h_msh/1e3,pl_plot,supp);
    set(h_s,'LineColor','k','LineStyle',':','LineWidth',1,...
        'LineWidth',0.1);
    [~,hg]=contour(m_msh,h_msh/1e3,gm/5280,0.4:0.1:1);
    set(hg,'LineColor','r','LineStyle','-.','LineWidth',1,...
        'ShowText','on','LabelSpacing',400);
    
    [~,hs]=contour(m_msh,h_msh/1e3,m_msh.*a(h_msh),[250,300]*1.4666);
    set(hs,'LineColor','c','LineStyle',':','LineWidth',1.5);
    
end
close(wb)
