function latticeout
%% Optima
% This script outputs a fairly large lattice plot comparing V_cruise, Range
% and L/D max. The output axis for the lattice plot will be Wing loading,
% WS and power req, P

% Alex M Granata
% 03 OCT 2015

close all; clear; clc

%% Initial Assumptions and Requirments of flight

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm
% Initial Performance Constants
sfc=0.5;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0.25;     % i.e. 25 min loiter time
AR=10;      % Aspect Ratio
Cd0=0.022;  % 
e=0.8;      % Oswald Efficency
% Cruise Enviromental Conditions
p_c=1.267e-3;  % slugs per ft^3
% Takeoff Distance
s_T=3000;   % ft
% WS Restraint Constants
Cl_max=1.8;  % Max C_L for takeoff
V_stall=65*1.688; % Stall speed in ft/s, Sea Level, max 65 knots
% Convience Conditions
K=1/(e*pi*AR);
V_md=@(ws,p) sqrt(2*ws/(p*sqrt(Cd0/K)));
p_sl=2.3769e-3; %slugs/ft^3, sea level density
% Service Ceiling
p_sc=.958e-3;   % slugs per ft^3

%% Domains of independent variables
Rl=5;  Rd=linspace(800,1200,Rl)*1.151;  %miles
Vl=21;  Vd=linspace(280,300,Vl)*1.466667;  %ft/sec
LDl=3;  LDd=linspace(18,22,LDl);  % Keep resolution of LD <5
% Resolution of independent, Secondary, variables
WSl=40;

% Definitions
% % For both cruise and climb conditions, leaving off 1/g(dV/dt) term
% TW_c=@(ws,p,V,n,hdot)...
%     (0.5*p*V.^2)*Cd0./ws+K*n^2./(0.5*p*V.^2).*ws+1./V*(hdot);
% Drag for Power
D=@(ws,v,p,wto) Cd0*0.5*p*v.^2.*(wto./ws)+K*ws*wto./(0.5*p*v.^2);

%% Numerical Calculations
% For loops to calculate WS, TW and P for independent Variables
tic
optimzd=zeros(Rl,Vl,LDl,2);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
    addAttachedFiles(gcp('nocreate'),'../cnstrnts');
end

for it_LD=1:LDl
    LD=LDd(it_LD);
    for it_R=1:Rl
        R=Rd(it_R);
        parfor it_V=1:Vl
            V_c=Vd(it_V);
            
            
            % Fuel Weight Fraction
            % Fuel ratios
            Wr=exp(-R*sfc/(V_c/1.46666667*(0.943*LD)));
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
            
            %             Min loading for to meet Range requirement
            WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));
            %             % Wing-loading min to meet C_L_max and V_stall assumptions
            %             WS_s=0.5*p_c*V_stall^2*Cl_max;
            % Limit on W/S for Landing Distance within required distance, 3 degree
            % angle of approach
            WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
                50,optimoptions('fsolve','display','off'));
            WSdom=linspace(WS_r,WS_l,WSl);
            
            % Takeoff Distance
            % W/S and T/W to takeoff at required distance
            s_tm=zeros(1,WSl);
            for a=1:WSl
                s_tm(a)=fsolve(@(tw) ...
                    s_T-(20.9*(WSdom(a)/(Cl_max*tw))+69.6*sqrt(WSdom(a)/(Cl_max*tw))*tw),...
                    0.5,optimoptions('fsolve','display','off'));
            end
            %             % Cruise Conditions
            %             % For Straight, Level Flight at cruise conditions
            %             TW_cruise=TW_c(WSdom,p_c,V_c,1,0);
            %             % For Service Ceiling, steady, constant speed, 100 ft per min
            %             TW_serv=TW_c(WSdom,p_sc,V_md(WSdom,p_sc),1,100/60);
            %             % For Cruise Ceiling, steady, constant speed, 300 ft/min
            %             TW_cc=TW_c(WSdom,p_c,V_md(WSdom,p_c),1,300/60);
            %             % Maneuver at Sea Level, cruise conditions, 2.5 g's
            %             TW_man=TW_c(WSdom,p_sl,V_c,2.5,0);  % Run WS/TW data
            
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
            [c,~]=max([Preq_cc;Preq_cruise;Preq_man;Preq_serv]);
            % Find the index of the minumum of 'c'
            [c2,in]=min(c);
            % Optimum is at WSdom(in),C2
            optm=[WSdom(in),c2/550];    % in lbs/ft^2 and hp
            
            optimzd(it_R,it_V,it_LD,:)=optm; % Save Optimized Data
        end
    end
end
toc
%% Figure Setup
% Base figure will be used to output the optimized Ws/Power, and control
% the other two design space and optimizer plots
bs=figure('Name','Optimized Power and Wing Loading',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','normalized',...
    'Resize','off',...
    'Position',[0 0.5 1 0.5]);

% Setup the axes for
abse=axes('Parent',bs);
abse.XLimMode='manual';
abse.Title.String='Power Requirments and Wing Loading';
abse.XLabel.String='Wing Loading W/S, lbs/ft^2 by LD_{max}';
abse.YLabel.String='Power_{Required}, hp';
hold(abse,'on')

% Details figure will be a split plot graphic the details of the selected
% point int he bas figure
f_det=figure('Name','Point Specifc Details',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','normalized',...
    'Resize','off',...
    'Position',[0 0.05 1 0.4]);
aTW=axes('Parent',f_det);
aTW.XLimMode='manual';
subplot(1,2,1,aTW);
aTW.Title.String='Constraints on Wing Loading and Specifc Thrust';
aTW.XLabel.String='Wing Loading W/S';
aTW.YLabel.String='Specfic Thrust: T/W';
hold(aTW,'on')
aPW=subplot(1,2,2);
aPW.Title.String='Operational Power Curves';
aPW.XLabel.String='Wing Loading W/S';
aPW.YLabel.String='Power_{Required}, hp';
hold(aPW,'on')

%% Setup Xaxis for Lattice Plot
abse.Units='pixels';
szax=abse.Position;
catlim=round(szax(3)/LDl/60-2,0);
rng=[min(min(min(optimzd(:,:,:,1)))),max(max(max(optimzd(:,:,:,1))))];
if log10(catlim)>1
    stepd=1;
else
    stepd=0;
end
magni=round(log10(rng(2)),0)-1-stepd;
% Determined magnitude of steps
optmsmag=[1,2,5];
rangeoptions=optmsmag'*10^magni*catlim;
[~,ir]=min(abs(rangeoptions-diff(rng)));
stepsz=optmsmag(ir)*10^(magni); %determine size of nominal steps
lbs=floor(rng(1)/stepsz)*stepsz:stepsz:ceil(rng(2)/stepsz)*stepsz; %Actual steps
x_ticklabel={' ',lbs};
x_tickvalue=1:((length(lbs)+1)*LDl);
abse.XTickLabel=x_ticklabel;
abse.XTick=x_tickvalue;
abse.XLim=[1 ((length(lbs)+1)*LDl)];

%% Plot the Optimized Data
% Split Lattice plot in order to display data

figure(bs);
axes(abse);
% Plot Each Carpet by successive LD settings
for a=1:LDl
    %     Velocity Dependant
    for b=1:Vl
        plot(abse,(a-1)*(length(lbs)+1)+1+...
            interp1(lbs,1:length(lbs),optimzd(:,b,a,1),'pchip'),...
            optimzd(:,b,a,2),'b-')
        if Vl*LDl>20
            if b==1 || b==Vl || b==round(Vl/2)
                text((a-1)*(length(lbs)+1)+1+...
                    interp1(lbs,1:length(lbs),optimzd(1,b,a,1),'pchip'),...
                    optimzd(1,b,a,2),...
                    sprintf('%0.0f mph',Vd(b)/1.46666667),...
                    'Verticalalignment','top','horizontalAlignment','center')
            else
                continue
            end
        else
            text((a-1)*(length(lbs)+1)+1+...
                interp1(lbs,1:length(lbs),optimzd(1,b,a,1),'pchip'),...
                optimzd(1,b,a,2),...
                sprintf('%0.0f mph',Vd(b)/1.46666667),...
                'Verticalalignment','top','horizontalAlignment','center')
        end
    end
    
    %     Range Dependant
    for c=1:Rl
        plot(abse,(a-1)*(length(lbs)+1)+1+...
            interp1(lbs,1:length(lbs),optimzd(c,:,a,1),'pchip'),...
            optimzd(c,:,a,2),'k-')
        if Rl>8
            if c==1 || b==Vl || b==round(Vl/2)
                text((a-1)*(length(lbs)+1)+1+...
                    interp1(lbs,1:length(lbs),optimzd(c,1,a,1),'pchip'),...
                    optimzd(c,1,a,2),...
                    sprintf('%0.0f nm',Rd(c)/1.151),...
                    'Verticalalignment','middle','horizontalAlignment','right')
            else
                continue
            end
        else
            text((a-1)*(length(lbs)+1)+1+...
                interp1(lbs,1:length(lbs),optimzd(c,1,a,1),'pchip'),...
                optimzd(c,1,a,2),...
                sprintf('%0.0f nm',Rd(c)/1.151),...
                'Verticalalignment','middle','horizontalAlignment','right')
        end
    end
end

% Connection Lines for LD_max boxes
ldconres=25;
for b=[1 Vl]
    for c=[1 Rl]
        tstr0(1:LDl)=optimzd(c,b,:,1); outr0(1:LDl)=optimzd(c,b,:,2);
        tstr1=((1:LDl)-1)*(length(lbs)+1)+1+...
            interp1(lbs,1:length(lbs),tstr0,'pchip');
        outr1=interp1(tstr1,outr0,linspace(tstr1(1),tstr1(end),ldconres),'pchip');
        plot(abse,linspace(tstr1(1),tstr1(end),ldconres),outr1,'Color',0.7*[1 1 1]);
    end
end

% Text Label for LD_Max
for a=1:LDl
    text((a-1)*(length(lbs)+1)+round(length(lbs)/2+1),...
        abse.YLim(1)+0.07*diff(abse.YLim),...
        sprintf('LD_{max}: %3.0f',LDd(a)),...
        'Color','g')
end

%% Data Tip Details and Updater
% Turn on Data Cursor mode for base figure, and assign the appropriate
% callback function to graph the details
bsdc=datacursormode(bs);
bsdc.UpdateFcn=@drawdetails;
bsdc.Enable='on';

    function output_txt = drawdetails(~,evntobj)
        % Used to output custom datatip information, as well as update the detail
        % graphs that show specic information about the selected data.
        pos = get(evntobj,'Position');
        posout=[interp1(1:length(lbs),lbs,pos(1)-floor(pos(1)/(length(lbs)+1))*(length(lbs)+1)-1),...
            pos(2)];
        output_txt = {['LDmax: ',num2str(LDd(floor(pos(1)/(length(lbs)+1))+1),3)],...
            ['WS: ',num2str(posout(1),4)],...
            ['P: ',num2str(posout(2),4)]};

        % Begin graphics
        [Rin,V_cin]=find(optimzd(:,:,floor(pos(1)/(length(lbs)+1))+1,2)==posout(2));
        R=Rd(Rin);
        V_c=Vd(V_cin);
        LD=LDd(floor(pos(1)/(length(lbs)+1))+1);
        WS_r=[]; WS_s=[]; WS_l=[]; TW_c=[]; TW_cruise=[]; TW_serv=[]; TW_cc=[];
        TW_man=[]; ym=[]; xm=[]; WSD=[];
        
        
        try
            cnstr_n
            power_cnstr_n
        end
    end

end