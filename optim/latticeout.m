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
D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);

%% Numerical Calculations
% For loops to calculate WS, TW and P for independent Variables
optimzd=zeros(Rl,Vl,LDl,2);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

parfor it_R=1:Rl
    R=Rd(it_R);
    for it_V=1:Vl
        V_c=Vd(it_V);
        for it_LD=1:LDl
              LD=LDd(it_LD);
              
              W_est;    % Estimate W_TO
              cnstr_n;  % Run WS/TW data
              power_n;  % Run WS/Power data
              power_optim;  % Run Optimizer for Ws/Power
              
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
X_wslabels=[{'',mat2cell(WSdom,1,WSl),''}]; % This will loop on the X Axis labels, so only one is needed
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


% 