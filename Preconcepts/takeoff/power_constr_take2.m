%% Power to Constraints
% Designed to take T/W data from Constraint Graphic, and transform that to
% Power required at Various Altitudes
close all; clear; clc
%% Assumptions about Aircraft Parameters
% This script addes asumption variables to the workspace
newassum

%% Takeoff Weight Estimation
% This script will run to determine estimated Gross Takeoff Weight, results
% in assignment to Wto
W_est

%% Ranges for W/S 
WSdom=linspace(5,60,25);
ms=length(WSdom);

%% Limits on W/S
% Wing-loading minimum to meet required Range
WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));

% Wing-loading min to meet C_L_max and V_stall assumptions
WS_s=0.5*p_c*V_stall^2*Cl_max;

% Limit on W/S for Landing Distance within required distance, 3 degree
% angle of approach
WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
    50,optimoptions('fsolve','display','off'));
    

%% 
WSdom=linspace(5,60,25);
ms=length(WSdom);

V_c=V_c*1.46666;
%% Cruise Conditions
% Equilvant Power to various altitudes 
D=@(ws,v,p) Cd0*0.5*p*v.^2.*(Wto./ws)+K*ws*Wto./(0.5*p*v.^2);

% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c)*V_c;
% Service Ceiling
Preq_serv=D(WSdom,V_md(WSdom,p_sc),p_sc).*V_md(WSdom,p_sc)+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_md(WSdom,p_c),p_sc).*V_md(WSdom,p_c)+...
    Wto*(300/60);
%% Takeoff Distance
% W/S and T/W to takeoff at required distance
s_tm=zeros(1,ms);
for a=1:ms
    s_tm(a)=fsolve(@(tw) ...
        s_T*2/3-(20.9*(WSdom(a)/(Cl_max*tw))+69.6*sqrt(WSdom(a)/(Cl_max*tw))*tw),...
        0.5,optimoptions('fsolve','display','off'));
end



%% Graphic Output
f2=figure(2); cla
hold on
plot(WSdom,Preq_cruise/550,'b--','Linewidth',1)
plot(WSdom,Preq_serv/550,'g--','Linewidth',1)
plot(WSdom,Preq_cc/550,'c--','Linewidth',1)
plot(WSdom,s_tm*Wto*V_stall*1.2/550,'r--','Linewidth',1)

%% Design Space

ym=[0 3000];
xm=xlim;

TWdom=linspace(ym(1),ym(2),ms);
[WSspace,TWspace]=meshgrid(WSdom,TWdom);
designspace=zeros(ms);
for a=1:ms
    for b=1:ms
        tstmat=[TWspace(a,b)>s_tm(b);
            TWspace(a,b)>Preq_cruise(b)/550;
            TWspace(a,b)>Preq_serv(b)/550;
            TWspace(a,b)>Preq_cc(b)/550;
%             TWspace(a,b)>s_tm(b)*Wto*V_stall*0.7*1.2/550;
            WSspace(a,b)>WS_r;
            WSspace(a,b)>WS_s;
            WSspace(a,b)<WS_l;];
        designspace(a,b)=all(tstmat);
    end
end
plot(WSspace(designspace==1),TWspace(designspace==1),'m.','MarkerSize',10)

%% WS Limits
plot(WS_r*ones(1,2),ym,'k-.','Linewidth',1)
plot(WS_s*ones(1,2),ym,'k-.','Linewidth',1)
plot(WS_l*ones(1,2),ym,'k-.','Linewidth',1)



%% Text and Such
% text(0.98*xm(2),0.75*ym(2),sprintf('W_{TO}=%6.0f lbs',Wto),...
%     'horizontalAlignment','right','verticalAlignment','bottom')
text(WS_r,0.95*ym(2),sprintf('Range WS_{Min} ->',R/1.151),...
    'horizontalAlignment','right','verticalAlignment','top','FontSize',14)
text(WS_s,0.85*ym(2),sprintf('Stall speed WS_{Min} ->',V_stall/1.688),...
    'horizontalAlignment','right','verticalAlignment','top','FontSize',14)
text(WS_l,0.95*ym(2),sprintf('<- Landing WS_{Max}',s_T),...
    'horizontalAlignment','left','verticalAlignment','top','FontSize',14)
ylim(ym)


legend({'Cruise','Ceiling_{service}','Ceiling_{cruise}','Takeoff',...
    'Design Space'},...
    'Location','east',...
    'FontSize',12);

xlabel('W/S \rightarrow increasing','FontSize',14)
ylabel('P_{req} \rightarrow increasing','FontSize',14)
set(gca,'Xtick',[])
set(gca,'YTick',[])
% title('Partior Q==1: Power Requirements','FontSize',16)


%% Figure Adjustment
r=gcf;
r.Units='inches';
% r.MenuBar='none';
r.Position=[3 3 11.5 6.5];

% [x,y]=meshgrid(linspace(xm(1),xm(2)),linspace(ym(1),ym(2)));
% ss=surf(x,y,y-ym(2),'EdgeColor','none','FaceColor','interp','FaceAlpha',0.6);
% cmap=colormap(colormap(copper(2^9)));
% colormap(cmap(2^7:end,:))
% 
% uistack(ss,'top')
ax=gca;
ax.Position=[0.05 0.075 0.9 0.9];
saveas(f2,'untitled.jpg','jpg')