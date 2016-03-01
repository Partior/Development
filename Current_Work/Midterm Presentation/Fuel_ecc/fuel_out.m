clear; close all; clc
data_f

%% Loading
ff=figure;
clf
sz=[8 3.5];    % size of actual picture, inches (axis not figure)
ssz=sz*diag(1./[0.7750 0.8150]);    % needed size of external figure
set(ff,'Units','inches','Position',[0.5 0.5 ssz]);  %size of axis will be the proper size for powerpoint
aa=axes;
hold on

ode_range; % call, variable r is output range
rrr=r/1.151;
p_gm=r/Wf*6.01*19; %partior's mpg per seat

plot(data_turbo(:,1),data_turbo(:,3),'c.','MarkerSize',10)
text(mean(data_turbo(:,1)),mean(data_turbo(:,3)),'Turboprop',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',12)
plot(data_regional(:,1),data_regional(:,3),'b.','MarkerSize',10)
text(mean(data_regional(:,1)),mean(data_regional(:,3)),'Regional',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',12)
plot(data_short(:,1),data_short(:,3),'m.','MarkerSize',10)
text(mean(data_short(:,1)),mean(data_short(:,3)),'Short Haul',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',12)
plot(rrr,p_gm,'r.','MarkerSize',20)
text(rrr,p_gm,'Partior',...
    'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'FontSize',12)
pp=polyfit([data_turbo(:,1);data_regional(:,1);data_short(:,1)],...
    [data_turbo(:,3);data_regional(:,3);data_short(:,3)],1);
fplot(@(x) polyval(pp,x),[0 1200],'k:')   % Trend Line

title('Comerical Aviation Fuel Economy')
aa.Title.FontSize=14;
xlabel('Range: R - nmi')
aa.XLabel.FontSize=14;
aa.FontSize=12;
ylabel('Fuel Economy: mil/gal per seat')
aa.YLabel.FontSize=14;
xlim([0 1200])
grid on