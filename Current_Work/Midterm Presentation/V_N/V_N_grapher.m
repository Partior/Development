%% Graphs the V_N diagram

figure(1); clf; hold on

plot(mdom,n_p,'r--')  % plot stall lift curve online line, upper
plot(mdom,n_n,'r--') % plot stall lift curve online line, lower

% stall locations
text(Vs_u/a(h),ns_u,'V_{stl up}','HorizontalAlignment','right','VerticalAlignment','bottom')
text(Vs_l/a(h),ns_l,'V_{stl dwn}','HorizontalAlignment','right','VerticalAlignment','top')
% cornering speed, upper
plot(Vau/a(h)*[1,1],[0,nmax],'k:')
text(Vau/a(h),0,'V_{crnr up}','HorizontalAlignment','center','VerticalAlignment','top')
% cornering speed, lower
plot(Val/a(h)*[1,1],[nmax*-0.4,0],'k:')
text(Val/a(h),0,'V_{crnr dwn}','HorizontalAlignment','center','VerticalAlignment','bottom')
% Cruise speed indicator
plot(Vc/a(h)*[1,1],[min(nmax*-0.4,gc(2,end)),max(nmax,gc(1,end))],'k:')
text(Vc/a(h),0,'V_{cruise}','HorizontalAlignment','center')
% Max speed indicator
plot(Vd/a(h)*[1,1],[nmax*-0.4,nmax],'k:')
text(Vd/a(h),0,'V_{max}','HorizontalAlignment','center')

plot(mdom(mdom*a(h)<Vau),gau,'b-.') % upper cornering gust
plot(mdom(mdom*a(h)<Val),gal,'b-.') % lower cornering gust
plot(mdom(mdom*a(h)<Vc),gc,'b-.')   % cruise gusts
plot(mdom(mdom*a(h)<Vd),gd,'b-.')   % max speed gusts

% Finally, plot the actuall curves of the VN diagram
plot(mdom,nu,'k-','LineWidth',1.5) 
plot(mdom,nl,'k-','LineWidth',1.5)

%% Pretty
xlabel('Mach'); ylabel('N Loading')
title({sprintf('V-N Diagram: N_{max} = %.1f',nmax);...
    'V-N Total, \color{red}Stall \color{black}and \color{blue}Gusts';...
    sprintf('Engines Used: %g - Altitude: %g',n_e,h)})
ylim([min(nmax*-0.4,gc(2,end))*1.5 max(nmax,gc(1,end))*1.5])
grid on