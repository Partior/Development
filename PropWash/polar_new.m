%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
% 
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Init
% run scripts to initalize variables
load('../ConceptCompar/constants.mat')
n=12; % reset number of props to redo prop_T
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone
%% Equations
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
Df=@(aoa,h,v) 1/2*p(h)*v^2*(CD0_plane(v,h)+(K*Cla(aoa)^2)*0.1)/beta(v/a(h))*(80*5); % 80*5 is length * diamter for approx surface area
Dw=@(aoa,h,v,on) (...
    1/2*p(h)*v^2*Cda(aoa)*((b-2*Rmax*on)*chrd)+...free stream wing drag
    1/2*p(h)*v2(v,T(v,h),h)^2*Cda(aoa*ang(v,h))*((2*Rmax*on)*chrd)); % prop wash drag
D=@(aoa,h,v,on) Df(aoa,h,v)+Dw(aoa,h,v,on);

%% Plotting
% Plotting a modified V-H Diagram
% Plot various number of engines at 100 and 75% power levels
% Stall line for each

[m_msh,h_msh]=meshgrid(linspace(0.1,0.8,40),linspace(0,52e3,40));
taoa=zeros(40);
pl=zeros(40);
% started at 0.1 mach to not have to deal with wierd AoAs

% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h)*on/n);
pl=zeros(40);

figure(1); clf; hold on
prim=[0.5 1];
supp=0.55:0.05:.95;
clr=['k','b','c','g','y','r'];
wb=waitbar(0,'Waiting');

for ne=[12]
    for ita=1:40
        waitbar(ita/40,wb)
        parfor itb=1:40
            hi=h_msh(ita,itb);
            vi=m_msh(ita,itb)*a(h_msh(ita,itb));
            taoa(ita,itb)=fsolve(@(rr) L(rr,hi,vi,ne)-W0(19),5,optimoptions('fsolve','Display','off'));
            if isnan(taoa(ita,itb))
                pl(ita,itb)=NaN;
            else
                pl(ita,itb)=plvl(taoa(ita,itb),hi,vi,ne);
            end
        end
    end
    cli=clr(ne/2);
    [~,h_m]=contour(m_msh,h_msh/1e3,pl,prim);
    set(h_m,'LineColor',cli,'LineStyle','-','LineWidth',1.5,...
        'LineWidth',1.5,...
        'ShowText','on','LabelSpacing',400);
    [~,h_s]=contour(m_msh,h_msh/1e3,pl,supp);
    set(h_s,'LineColor',cli,'LineStyle',':','LineWidth',1,...
        'LineWidth',0.1);
end
close(wb)
