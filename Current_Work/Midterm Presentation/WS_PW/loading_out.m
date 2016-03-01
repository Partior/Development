%% Graphical Output
clear; close all; clc
prop_const
prop_T
data

%% Loading
ff=figure;
clf
sz=[8 3.5];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff,'Units','inches','Position',[0.5 0.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
plot(cell2mat({data_ws_pw.W_S})',cell2mat({data_ws_pw.P_W})','k.','MarkerSize',20)
plot(data_ws_pw(end).W_S,data_ws_pw(end).P_W,'b.','MarkerSize',20)
text(cell2mat({data_ws_pw.W_S})',cell2mat({data_ws_pw.P_W})',{data_ws_pw.name},...
    'HorizontalAlignment','center','VerticalAlignment','top',...
    'FontSize',12)
pp=polyfit(cell2mat({data_ws_pw.W_S})',cell2mat({data_ws_pw.P_W})',1);
fplot(@(x) polyval(pp,x),[30,65],'k:')   % Trend Line

title('Comparitor Aircraft Loading')
aa.Title.FontSize=14;
xlabel('Wing Loading: W/S, lbs/ft^2')
aa.XLabel.FontSize=14;
aa.FontSize=12;
ylabel('Power Loading: P/W hp/lbs')
aa.YLabel.FontSize=14;
xlim([25 70])
ylim([0.05 0.11])

%% Range/Mass
ff2=figure;
clf
set(ff2,'Units','inches','Position',[0.5 5.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
plot(cell2mat({data_ws_pw.weight})'/1000,cell2mat({data_ws_pw.range})','k.','MarkerSize',20)
plot(data_ws_pw(end).weight/1000,data_ws_pw(end).range,'b.','MarkerSize',20)
text(cell2mat({data_ws_pw.weight})'/1000,cell2mat({data_ws_pw.range})',{data_ws_pw.name},...
    'HorizontalAlignment','center','VerticalAlignment','top',...
    'FontSize',12)
pp=polyfit(cell2mat({data_ws_pw.weight})'/1000,cell2mat({data_ws_pw.range})',1);
fplot(@(x) polyval(pp,x),[12,18],'k:')   % Trend Line

title('Comparator Weight and Range')
aa.Title.FontSize=14;
xlabel('Weight: TOGW, 1,000 lbs')
aa.XLabel.FontSize=14;
aa.FontSize=12;
ylabel('Range: R, nmi')
aa.YLabel.FontSize=14;
xlim([10 20])
ylim([0 1400])