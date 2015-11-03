<<<<<<< HEAD
function latticeout2
%% Optima
% This script outputs a fairly large lattice plot comparing V_cruise, Range
% and L/D max. The output axis for the lattice plot will be Wing loading,
% WS and power req, P

% Alex M Granata
% 03 OCT 2015

close all; clear; clc

%% Initial Assumptions and Requirments of flight
% load('constants.mat');

%% Domains of independent variables
% Range is now locked to 800 nm
ARl=15; ARd=linspace(8,12,ARl); % Aspect Ratio
Vl=15;  Vd=linspace(250,300,Vl)*1.46666;  %ft/sec
% LD is now a function of Velocity
hcl=15;   hcd=linspace(8e3,28e3,hcl); % cruise altitude
splinepp=[];
load('airden.mat','splinepp');
WTOl=4; % Number of isolines for the WTO contours

%% Numerical Calculations
% For loops to calculate WS, TW and P for independent Variables
optimzd=zeros(ARl,hcl,Vl,3);
tmr=zeros(ARl,hcl,Vl);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

wtb=waitbar(0,'Running Iterations and Optimizations');
for it_hc=1:hcl
    for it_V=1:Vl
        waitbar((it_hc*Vl+it_V)/(it_hc*it_Vl),wtb)
        parfor it_AR=1:ARl
            AR=ARd(it_AR);
            tic
            tmp=cnstr2(AR,Vd(it_V),exp(ppval(splinepp,hcd(it_hc))),...
                0,0,false);    % in lbs/ft^2 and P/Wto
            if isempty(tmp)
                optimzd(it_AR,it_hc,it_V,:)=[0,0,0];
            else
                optimzd(it_AR,it_hc,it_V,:)=tmp;
            end
            tmr(it_AR,it_hc,it_V)=toc;
        end
    end
end

fprintf('Total Computation time: %0.4g \n Averge: %0.4g \n',...
    sum(sum(sum(tmr))),mean(mean(mean(tmr))))
save('optimz.mat','optimzd','ARd','Vd','hcd')
clear V_c LD R mat Preq_cruise Preq_cc Preq_man Preq_serv Preq_TOop
clear WS_r WS_s WS_l wsx optm VTO T0t TO a A mu Cdg CLg B s D
%% Figure Setup
% Base figure will be used to output the optimized Ws/Power, and control
% the other two design space and optimizer plots
r=groot;
if size(r.MonitorPositions,1)>1
    if prod(r.MonitorPositions(1,3:4))>prod(r.MonitorPositions(2,3:4))
        bspos=r.MonitorPositions(1,:);
        f_detpos=r.MonitorPositions(2,:);
    else
        bspos=r.MonitorPositions(2,:);
        f_detpos=r.MonitorPositions(1,:);
    end
else
    bspos=r.MonitorPositions(1,:).*[1 1 1 0.5];
    f_detpos=[r.MonitorPositions(1,1),r.MonitorPositions(1,4)/2,r.MonitorPositions(1,3:4).*[1 0.5]];
end

bs=figure('Name','Optimized Power and Wing Loading',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','pixels',...     'Resize','off',...
    'Position',bspos,...
    'deletefcn','close all; clear; clc;');

% Setup the axes for
abse=axes('Parent',bs);
abse.XLimMode='manual';
abse.Title.String='Power Requirments and Wing Loading';
abse.XLabel.String='Wing Loading W/S, lbs/ft^2 by LD_{max}';
abse.YLabel.String='Power_{Required}, hp';
abse.Color='none';
hold(abse,'on')

% Details figure will be a split plot graphic the details of the selected
% point int he bas figure
f_det=figure('Name','Point Specifc Details',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','pixels',...'Resize','off',...
    'Position',f_detpos,...
    'deletefcn','close all; clear; clc;');
aTW=axes('Parent',f_det);
aTW.XLimMode='manual';
aTW.Title.String='Constraints on Wing Loading and Specifc Thrust';
aTW.XLabel.String='Wing Loading W/S';
aTW.YLabel.String='Power: hp';
hold(aTW,'on')

savefig(f_det,'figurhandles.fig')

clear r bspos f_detpos
%% Setup Xaxis for Lattice Plot
abse.Units='pixels';
szax=abse.Position;
abse.Units='normalized';
catlim=round(szax(3)/Vl/50-2,0);
rnge=[min(min(min(optimzd(:,:,:,1)))),max(max(max(optimzd(:,:,:,1))))];
magni=round(log10(diff(rnge)))-1;
% Determined magnitude of steps
optmsmag=[1,2,5];
rangeoptions=optmsmag'*10^magni*catlim;
[~,ir]=min(abs(rangeoptions-diff(rnge)));
stepsz=optmsmag(ir)*10^(magni); %determine size of nominal steps
lbs=floor(rnge(1)/stepsz)*stepsz:stepsz:ceil(rnge(2)/stepsz)*stepsz; %Actual steps
x_ticklabel={' ',lbs};
x_tickvalue=1:((length(lbs)+1)*Vl);
abse.XTickLabel=x_ticklabel;
abse.XTick=x_tickvalue;
abse.XLim=[1 ((length(lbs)+1)*Vl)];

clear szax catlim rnge magni optmsmag rangeoptions ir stepsz
%% Plot the V/R Optimized Data
% Split Lattice plot in order to display data

figure(bs);
axes(abse);
xint=zeros(ARl,hcl,Vl);
yint=zeros(ARl,hcl,Vl);
% Plot Each Carpet by successive LD settings
for a=1:Vl
    %     Velocity Dependant
    for b=1:hcl
        xint(:,b,a)=(a-1)*(length(lbs)+1)+1+interp1(lbs,1:length(lbs),optimzd(:,b,a,1),'pchip');
        plot(abse,xint(:,b,a), optimzd(:,b,a,2),'Color',0.8*[1 1 1])
        if hcl*Vl>20
            if b==1 || b==hcl || b==round(hcl/2)
                text(xint(1,b,a),...
                    optimzd(1,b,a,2),...
                    sprintf('%.4g',hcd(b)),...
                    'Verticalalignment','top','horizontalAlignment','left')
            else
                continue
            end
        else
            text(xint(1,b,a),...
                optimzd(1,b,a,2),...
                sprintf('%.4g',hcd(b)),...
                'Verticalalignment','top','horizontalAlignment','left')
        end
    end
    
    %     Range Dependant
    for c=1:ARl
        yint(c,:,a)=(a-1)*(length(lbs)+1)+1+interp1(lbs,1:length(lbs),optimzd(c,:,a,1),'pchip');
        plot(abse,yint(c,:,a),optimzd(c,:,a,2),'Color',0.8*[1 1 1])
        if ARl>5
            if c==1 || c==ARl || c==round(ARl/2)
                text(yint(c,1,a),...
                    optimzd(c,1,a,2),...
                    sprintf('%.4g',ARd(c)),...
                    'Verticalalignment','middle','horizontalAlignment','right')
            else
                continue
            end
        else
            text(yint(c,1,a),...
                optimzd(c,1,a,2),...
                sprintf('%.4g',ARd(c)/1.151),...
                'Verticalalignment','middle','horizontalAlignment','right')
        end
    end
end

clear yint

%% LD Max Indicators
% Connection Lines for LD_max boxes
ldconres=25;
for b=[1 hcl]
    for c=[1 ARl]
        tstr0(1:Vl)=optimzd(c,b,:,1); outr0(1:Vl)=optimzd(c,b,:,2);
        tstr1=((1:Vl)-1)*(length(lbs)+1)+1+...
            interp1(lbs,1:length(lbs),tstr0,'pchip');
        outr1=interp1(tstr1,outr0,linspace(tstr1(1),tstr1(end),ldconres),'pchip');
        plot(abse,linspace(tstr1(1),tstr1(end),ldconres),outr1,'Color',0.8*[1 1 1]);
    end
end

% Text Label for LD_Max
for a=1:Vl
    text((a-1)*(length(lbs)+1)+round(length(lbs)/2+1),...
        abse.YLim(1)+0.93*diff(abse.YLim),...
        sprintf('%.3g',Vd(a)),...
        'HorizontalAlignment','center','Color','r')
end

clear tstr0 tstr1 outr0 outr1
%% Gross Takeoff Weight Isolines
% Draw isolines on each independante carpet plot of the W_TO for the V/R
% pairing. This plot is unique such that it all has to be done at once, so
% that a colorbar may be added to the side of the plot for indications

% First, define an axis that matches directly on top of abse
abs2=axes('Parent',bs);
abs2.Units='pixels';
abs2.XLimMode='manual';
abs2.Title.String=' ';
abs2.XLabel.String=' ';
abs2.YLabel.String=' ';
hold(abs2,'on')
abs2.XTickLabel=' ';
abs2.XTick=x_tickvalue;
abs2.XColor='none'; abs2.YColor='none';
abs2.XLimMode='manual'; abs2.XLim=abse.XLim;
abs2.YLimMode='manual'; abs2.YLim=abse.YLim;
abs2.ZLimMode='manual';
bs.Children=[bs.Children(2);bs.Children(1)];

% Grab C data from each WTO/LD system,
for a=1:Vl
    xint0=xint(:,:,a);
    optimzd0=optimzd(:,:,a,2);
    optimzd1=optimzd(:,:,a,3)/1000;
    contour(abs2,xint0,optimzd0,optimzd1,WTOl,'LineWidth',1.3);
end
clb=colorbar;
clb.Label.String='W_{gross takeoff}, 1,000 lbs';
abse.Units='pixels'; 
abse.Position=abs2.Position;
abse.Units='normalized'; abs2.Units='normalized';

clear xint optimzd0 optimzd1

%% Data Tip Details and Updater
% Turn on Data Cursor mode for base figure, and assign the appropriate
% callback function to graph the details
bs.CurrentAxes=abse;
bsdc=datacursormode(bs);
bsdc.UpdateFcn=@drawdetails;
bsdc.Enable='on';

    function output_txt = drawdetails(~,evntobj)
        % Used to output custom datatip information, as well as update the detail
        % graphs that show specic information about the selected data.
        pos = get(evntobj,'Position');
        ldind=floor(pos(1)/(length(lbs)+1))+1;
        ldout=Vd(ldind);
        [ri,ci]=find(optimzd(:,:,ldind,2)==pos(2));
        if length(ri)>1
            ri=ri(1);
        end
        if length(ci)>1
            ci=ci(1);
        end
        WSout=optimzd(ri,ci,ldind,1);
        Wto_out=optimzd(ri,ci,ldind,3);
        posout=[interp1(1:length(lbs),lbs,pos(1)-floor(pos(1)/(length(lbs)+1))*(length(lbs)+1)-1),...
            pos(2)];
        output_txt = {['V_c: ',num2str(ldout,3)],...
            ['WS: ',num2str(WSout,4)],...
            ['P: ',num2str(pos(2),4)],...
            ['W_{takeoff}:  ',sprintf('%.0f',Wto_out)]};

        % Begin graphics
        [Rin,V_cin]=find(optimzd(:,:,floor(pos(1)/(length(lbs)+1))+1,2)==pos(2));
        if length(Rin)>1
            Rin=Rin(1);
        end
        if length(V_cin)>1
            V_cin=V_cin(1);
        end
        AR=ARd(Rin);
        hc=hcd(V_cin);
        V_c=Vd(floor(pos(1)/(length(lbs)+1))+1);
        
        keyboard
        cnstr2(AR,V_c,exp(ppval(splinepp,hc)),...
                posout,f_det,true);
    end

=======
function latticeout2
%% Optima
% This script outputs a fairly large lattice plot comparing V_cruise, Range
% and L/D max. The output axis for the lattice plot will be Wing loading,
% WS and power req, P

% Alex M Granata
% 03 OCT 2015

close all; clear; clc

%% Initial Assumptions and Requirments of flight
% load('constants.mat');

%% Domains of independent variables
% Range is now locked to 800 nm
ARl=15; ARd=linspace(8,12,ARl); % Aspect Ratio
Vl=15;  Vd=linspace(250,300,Vl)*1.46666;  %ft/sec
% LD is now a function of Velocity
hcl=15;   hcd=linspace(8e3,28e3,hcl); % cruise altitude
splinepp=[];
load('airden.mat','splinepp');
WTOl=4; % Number of isolines for the WTO contours

%% Numerical Calculations
% For loops to calculate WS, TW and P for independent Variables
optimzd=zeros(ARl,hcl,Vl,3);
tmr=zeros(ARl,hcl,Vl);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

wtb=waitbar(0,'Running Iterations and Optimizations');
for it_hc=1:hcl
    for it_V=1:Vl
        waitbar((it_hc*Vl+it_V)/(it_hc*it_Vl),wtb)
        parfor it_AR=1:ARl
            AR=ARd(it_AR);
            tic
            tmp=cnstr2(AR,Vd(it_V),exp(ppval(splinepp,hcd(it_hc))),...
                0,0,false);    % in lbs/ft^2 and P/Wto
            if isempty(tmp)
                optimzd(it_AR,it_hc,it_V,:)=[0,0,0];
            else
                optimzd(it_AR,it_hc,it_V,:)=tmp;
            end
            tmr(it_AR,it_hc,it_V)=toc;
        end
    end
end

fprintf('Total Computation time: %0.4g \n Averge: %0.4g \n',...
    sum(sum(sum(tmr))),mean(mean(mean(tmr))))
save('optimz.mat','optimzd','ARd','Vd','hcd')
clear V_c LD R mat Preq_cruise Preq_cc Preq_man Preq_serv Preq_TOop
clear WS_r WS_s WS_l wsx optm VTO T0t TO a A mu Cdg CLg B s D
%% Figure Setup
% Base figure will be used to output the optimized Ws/Power, and control
% the other two design space and optimizer plots
r=groot;
if size(r.MonitorPositions,1)>1
    if prod(r.MonitorPositions(1,3:4))>prod(r.MonitorPositions(2,3:4))
        bspos=r.MonitorPositions(1,:);
        f_detpos=r.MonitorPositions(2,:);
    else
        bspos=r.MonitorPositions(2,:);
        f_detpos=r.MonitorPositions(1,:);
    end
else
    bspos=r.MonitorPositions(1,:).*[1 1 1 0.5];
    f_detpos=[r.MonitorPositions(1,1),r.MonitorPositions(1,4)/2,r.MonitorPositions(1,3:4).*[1 0.5]];
end

bs=figure('Name','Optimized Power and Wing Loading',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','pixels',...     'Resize','off',...
    'Position',bspos,...
    'deletefcn','close all; clear; clc;');

% Setup the axes for
abse=axes('Parent',bs);
abse.XLimMode='manual';
abse.Title.String='Power Requirments and Wing Loading';
abse.XLabel.String='Wing Loading W/S, lbs/ft^2 by LD_{max}';
abse.YLabel.String='Power_{Required}, hp';
abse.Color='none';
hold(abse,'on')

% Details figure will be a split plot graphic the details of the selected
% point int he bas figure
f_det=figure('Name','Point Specifc Details',...
    'NumberTitle','off',...
    'DockControls','off',...
    'MenuBar','none',...
    'Units','pixels',...'Resize','off',...
    'Position',f_detpos,...
    'deletefcn','close all; clear; clc;');
aTW=axes('Parent',f_det);
aTW.XLimMode='manual';
aTW.Title.String='Constraints on Wing Loading and Specifc Thrust';
aTW.XLabel.String='Wing Loading W/S';
aTW.YLabel.String='Power: hp';
hold(aTW,'on')

savefig(f_det,'figurhandles.fig')

clear r bspos f_detpos
%% Setup Xaxis for Lattice Plot
abse.Units='pixels';
szax=abse.Position;
abse.Units='normalized';
catlim=round(szax(3)/Vl/50-2,0);
rnge=[min(min(min(optimzd(:,:,:,1)))),max(max(max(optimzd(:,:,:,1))))];
magni=round(log10(diff(rnge)))-1;
% Determined magnitude of steps
optmsmag=[1,2,5];
rangeoptions=optmsmag'*10^magni*catlim;
[~,ir]=min(abs(rangeoptions-diff(rnge)));
stepsz=optmsmag(ir)*10^(magni); %determine size of nominal steps
lbs=floor(rnge(1)/stepsz)*stepsz:stepsz:ceil(rnge(2)/stepsz)*stepsz; %Actual steps
x_ticklabel={' ',lbs};
x_tickvalue=1:((length(lbs)+1)*Vl);
abse.XTickLabel=x_ticklabel;
abse.XTick=x_tickvalue;
abse.XLim=[1 ((length(lbs)+1)*Vl)];

clear szax catlim rnge magni optmsmag rangeoptions ir stepsz
%% Plot the V/R Optimized Data
% Split Lattice plot in order to display data

figure(bs);
axes(abse);
xint=zeros(ARl,hcl,Vl);
yint=zeros(ARl,hcl,Vl);
% Plot Each Carpet by successive LD settings
for a=1:Vl
    %     Velocity Dependant
    for b=1:hcl
        xint(:,b,a)=(a-1)*(length(lbs)+1)+1+interp1(lbs,1:length(lbs),optimzd(:,b,a,1),'pchip');
        plot(abse,xint(:,b,a), optimzd(:,b,a,2),'Color',0.8*[1 1 1])
        if hcl*Vl>20
            if b==1 || b==hcl || b==round(hcl/2)
                text(xint(1,b,a),...
                    optimzd(1,b,a,2),...
                    sprintf('%.4g',hcd(b)),...
                    'Verticalalignment','top','horizontalAlignment','left')
            else
                continue
            end
        else
            text(xint(1,b,a),...
                optimzd(1,b,a,2),...
                sprintf('%.4g',hcd(b)),...
                'Verticalalignment','top','horizontalAlignment','left')
        end
    end
    
    %     Range Dependant
    for c=1:ARl
        yint(c,:,a)=(a-1)*(length(lbs)+1)+1+interp1(lbs,1:length(lbs),optimzd(c,:,a,1),'pchip');
        plot(abse,yint(c,:,a),optimzd(c,:,a,2),'Color',0.8*[1 1 1])
        if ARl>5
            if c==1 || c==ARl || c==round(ARl/2)
                text(yint(c,1,a),...
                    optimzd(c,1,a,2),...
                    sprintf('%.4g',ARd(c)),...
                    'Verticalalignment','middle','horizontalAlignment','right')
            else
                continue
            end
        else
            text(yint(c,1,a),...
                optimzd(c,1,a,2),...
                sprintf('%.4g',ARd(c)/1.151),...
                'Verticalalignment','middle','horizontalAlignment','right')
        end
    end
end

clear yint

%% LD Max Indicators
% Connection Lines for LD_max boxes
ldconres=25;
for b=[1 hcl]
    for c=[1 ARl]
        tstr0(1:Vl)=optimzd(c,b,:,1); outr0(1:Vl)=optimzd(c,b,:,2);
        tstr1=((1:Vl)-1)*(length(lbs)+1)+1+...
            interp1(lbs,1:length(lbs),tstr0,'pchip');
        outr1=interp1(tstr1,outr0,linspace(tstr1(1),tstr1(end),ldconres),'pchip');
        plot(abse,linspace(tstr1(1),tstr1(end),ldconres),outr1,'Color',0.8*[1 1 1]);
    end
end

% Text Label for LD_Max
for a=1:Vl
    text((a-1)*(length(lbs)+1)+round(length(lbs)/2+1),...
        abse.YLim(1)+0.93*diff(abse.YLim),...
        sprintf('%.3g',Vd(a)),...
        'HorizontalAlignment','center','Color','r')
end

clear tstr0 tstr1 outr0 outr1
%% Gross Takeoff Weight Isolines
% Draw isolines on each independante carpet plot of the W_TO for the V/R
% pairing. This plot is unique such that it all has to be done at once, so
% that a colorbar may be added to the side of the plot for indications

% First, define an axis that matches directly on top of abse
abs2=axes('Parent',bs);
abs2.Units='pixels';
abs2.XLimMode='manual';
abs2.Title.String=' ';
abs2.XLabel.String=' ';
abs2.YLabel.String=' ';
hold(abs2,'on')
abs2.XTickLabel=' ';
abs2.XTick=x_tickvalue;
abs2.XColor='none'; abs2.YColor='none';
abs2.XLimMode='manual'; abs2.XLim=abse.XLim;
abs2.YLimMode='manual'; abs2.YLim=abse.YLim;
abs2.ZLimMode='manual';
bs.Children=[bs.Children(2);bs.Children(1)];

% Grab C data from each WTO/LD system,
for a=1:Vl
    xint0=xint(:,:,a);
    optimzd0=optimzd(:,:,a,2);
    optimzd1=optimzd(:,:,a,3)/1000;
    contour(abs2,xint0,optimzd0,optimzd1,WTOl,'LineWidth',1.3);
end
clb=colorbar;
clb.Label.String='W_{gross takeoff}, 1,000 lbs';
abse.Units='pixels'; 
abse.Position=abs2.Position;
abse.Units='normalized'; abs2.Units='normalized';

clear xint optimzd0 optimzd1

%% Data Tip Details and Updater
% Turn on Data Cursor mode for base figure, and assign the appropriate
% callback function to graph the details
bs.CurrentAxes=abse;
bsdc=datacursormode(bs);
bsdc.UpdateFcn=@drawdetails;
bsdc.Enable='on';

    function output_txt = drawdetails(~,evntobj)
        % Used to output custom datatip information, as well as update the detail
        % graphs that show specic information about the selected data.
        pos = get(evntobj,'Position');
        ldind=floor(pos(1)/(length(lbs)+1))+1;
        ldout=Vd(ldind);
        [ri,ci]=find(optimzd(:,:,ldind,2)==pos(2));
        if length(ri)>1
            ri=ri(1);
        end
        if length(ci)>1
            ci=ci(1);
        end
        WSout=optimzd(ri,ci,ldind,1);
        Wto_out=optimzd(ri,ci,ldind,3);
        posout=[interp1(1:length(lbs),lbs,pos(1)-floor(pos(1)/(length(lbs)+1))*(length(lbs)+1)-1),...
            pos(2)];
        output_txt = {['V_c: ',num2str(ldout,3)],...
            ['WS: ',num2str(WSout,4)],...
            ['P: ',num2str(pos(2),4)],...
            ['W_{takeoff}:  ',sprintf('%.0f',Wto_out)]};

        % Begin graphics
        [Rin,V_cin]=find(optimzd(:,:,floor(pos(1)/(length(lbs)+1))+1,2)==pos(2));
        if length(Rin)>1
            Rin=Rin(1);
        end
        if length(V_cin)>1
            V_cin=V_cin(1);
        end
        AR=ARd(Rin);
        hc=hcd(V_cin);
        V_c=Vd(floor(pos(1)/(length(lbs)+1))+1);
        
        keyboard
        cnstr2(AR,V_c,exp(ppval(splinepp,hc)),...
                posout,f_det,true);
    end

>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
end