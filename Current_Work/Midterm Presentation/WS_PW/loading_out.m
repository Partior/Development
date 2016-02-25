%% Graphical Output
clear; close all; clc
data

%% Loading
ff=figure;
clf
sz=[8.5 4];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff,'Units','inches','Position',[0.5 0.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
plot(cell2mat({dd.W_S})',cell2mat({dd.P_W})','k.','MarkerSize',20)
plot(dd(end).W_S,dd(end).P_W,'b.','MarkerSize',20)
text(cell2mat({dd.W_S})',cell2mat({dd.P_W})',{dd.name},...
    'HorizontalAlignment','center','VerticalAlignment','top',...
    'FontSize',12)
pp=polyfit(cell2mat({dd.W_S})',cell2mat({dd.P_W})',1);
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
sz=[8.5 4];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff2,'Units','inches','Position',[0.5 5.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on
plot(cell2mat({dd.weight})'/1000,cell2mat({dd.range})','k.','MarkerSize',20)
plot(dd(end).weight/1000,dd(end).range,'b.','MarkerSize',20)
text(cell2mat({dd.weight})'/1000,cell2mat({dd.range})',{dd.name},...
    'HorizontalAlignment','center','VerticalAlignment','top',...
    'FontSize',12)
pp=polyfit(cell2mat({dd.weight})'/1000,cell2mat({dd.range})',1);
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