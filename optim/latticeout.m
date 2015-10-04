function latticeout
%% Optima
% This script outputs a fairly large lattice plot comparing V_cruise, Range
% and L/D max. The output axis for the lattice plot will be Wing loading,
% WS and power req, P

% Alex M Granata
% 03 OCT 2015

clc

%% Initial Assumptions and Requirments of flight

addpath('..\cnstrnts'); % needed for scripts
assumer     % basic assumptions and requirements

% Domains of independent variables
Rl=15;  Rd=linspace(700,1800,Rl);
Vl=15;  Vd=linspace(200,350,Vl);
LDl=3;  LDd=linspace(15,23,LDl);  % Keep resolution of LD <5
% Domains of independent, Secondary, variables
WSl=25; WSdom=linspace(5,60,WSl);

% Definitions
% For both cruise and climb conditions, leaving off 1/g(dV/dt) term
TW_c=@(ws,p,V,n,hdot)...
    (0.5*p*V.^2)*Cd0./ws+K*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);
% Drag for Power
D=@(ws,v,p,wto) Cd0*0.5*p*v.^2.*(wto./ws)+K*ws*wto./(0.5*p*v.^2);

%% Numerical Calculations
% For loops to calculate WS, TW and P for independent Variables
optimzd=zeros(Rl,Vl,LDl,2);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
    addAttachedFiles(gcp('nocreate'),'../cnstrnts');
end

for it_LD=1:LDl
    for it_R=1:Rl
        parfor it_V=1:Vl
            LD=LDd(it_LD);
            R=Rd(it_R);
            V_c=Vd(it_V);            

            
% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-R*sfc/(V_c*(0.943*LD)));
We=exp(-E*sfc/(LD));
% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);
% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;
% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));    % Estimate W_TO

WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));
% Wing-loading min to meet C_L_max and V_stall assumptions
WS_s=0.5*p_c*V_stall^2*Cl_max;
% Limit on W/S for Landing Distance within required distance, 3 degree
% angle of approach
WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
    50,optimoptions('fsolve','display','off'));
% Takeoff Distance
% W/S and T/W to takeoff at required distance
s_tm=zeros(1,WSl);
for a=1:WSl
    s_tm(a)=fsolve(@(tw) ...
        s_T-(20.9*(WSdom(a)/(Cl_max*tw))+69.6*sqrt(WSdom(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end
% Cruise Conditions
% For Straight, Level Flight at cruise conditions
TW_cruise=TW_c(WSdom,p_c,V_c,1,0);
% For Service Ceiling, steady, constant speed, 100 ft per min
TW_serv=TW_c(WSdom,p_sc,V_md(WSdom,p_sc),1,100/60);
% For Cruise Ceiling, steady, constant speed, 300 ft/min
TW_cc=TW_c(WSdom,p_c,V_md(WSdom,p_c),1,300/60);
% Maneuver at Sea Level, cruise conditions, 2.5 g's
TW_man=TW_c(WSdom,p_sl,V_c,2.5,0);  % Run WS/TW data

% Calculations for Power
% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c,Wto)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSdom,V_md(WSdom,p_sc),p_sc,Wto).*V_md(WSdom,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_md(WSdom,p_c),p_sc,Wto).*V_md(WSdom,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSdom,V_c,p_sl,Wto)*V_c/(p_sl/p_sl);

% Find Max of any given operation at any point:
[c,refin]=max([Preq_cc;Preq_cruise;Preq_man;Preq_serv]);
% Find the index of the minumum of 'c'
[c2,in]=min(c);
% Optimum is at WSdom(in),C2
optm=[WSdom(in),c2/550];    % in lbs/ft^2 and hp
            
            optimzd(it_R,it_V,it_LD,:)=optm; % Save Optimized Data
        end
    end
end

%% Figure Setup
% Base figure will be used to output the optimized Ws/Power, and control
% the other two design space and optimizer plots 
bs=figure('Name','Optimized Power and Wing Loading',...
    'DeleteFcn','clear all',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','normalized',...
    'Resize','off',...
    'Position',[0 0.5 1 0.5],...
    'Visible','off'); clf;
% Turn on Data Cursor mode for base figure, and assign the appropriate
% callback function to graph the details
bsdc=datacursormode(bs);
bsdc.UpdateFcn=@drawdetails;
% Setup the axes for 
abs=axes('Parent',bs);
abs.Title.String='Power Requirments and Wing Loading';
abs.XLabel.String='Wing Loading W/S, lbs/ft^2 by LD_{max}';
abs.YLabel.String='Power_{Required}, hp';
    
% Details figure will be a split plot graphic the details of the selected
% point int he bas figure
f_det=figure('Name','Point Specifc Details',...
    'DeleteFcn','clear all',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','normalized',...
    'Resize','off',...
    'Position',[0 0.1 1 0.4],...
    'Visible','off'); clf;
aTW=axes('Parent',f_det);
subplot(1,2,1,aTW);
aTW.Title.String='Constraints on Wing Loading and Specifc Thrust';
aTW.XLabel.String='Wing Loading W/S';
aTW.YLabel.String='Specfic Thrust: T/W';
aPW=subplot(1,2,2);
aPW.Title.String='Operational Power Curves';
aPW.XLabel.String='Wing Loading W/S';
aPW.YLabel.String='Power_{Required}, hp';

%% Plot the Optimized Data
% Split Lattice plot in order to display data

% First, Orginization of the X-axis from WSdom
X_wslabels={'',mat2cell(WSdom,1,WSl),''}; % This will loop on the X Axis labels, so only one is needed
X_wsvalues=1:(LDl*(WSl+2)); % This will be the reference to plot onto the Xaxis with
abs.XTick=X_wsvales;
abs.XTickLabel=X_wslabels;

% Plot Each Carpet by successive LD settings
for a=1:LDl
    % Velocity Dependant
    for b=1:sz(1)
        plot((1:sz(2))+interp1(W(:,1),1:sz(1),W(a,1))-1,W(a,:),'b')
        text(1+interp1(W(:,1),1:sz(2),W(a,1))-1,W(a,1),sprintf('%0.0f',vd(a,1)),...
            'Verticalalignment','top','horizontalAlignment','center')
    end
    
    % Range Dependant
    for c=1:sz(2)
        plot((1:sz(1))+interp1(W(1,:),1:sz(2),W(1,b))-1,W(:,b),'b')
        text(1+interp1(W(1,:),1:sz(2),W(1,b))-1,W(1,b),sprintf('%0.0f',rd(1,b)),...
            'Verticalalignment','middle','horizontalAlignment','right')
    end

end