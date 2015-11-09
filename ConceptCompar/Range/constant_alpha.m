clear; clc

load('../constants.mat')

wb=waitbar(0,'Waiting, Constant AoA');
optm=zeros(hc,pyc,6);
for ith=1:hc
    parfor itp=1:pyc
        [t,r]=ode45(@DR2,[0 800*60],...
            [0,V0,W0(pdom(itp)),pdom(itp),p(hdom(ith))],...
            odeset('RelTol',RT));
        t=t(diff(r(:,1))~=0);
        r=r((diff(r(:,1))~=0),:);
        
        cl=W0(pdom(itp))/(0.5*p(hdom(ith))*V0^2*S);
        Cd=0.02+K*cl^2;
        T=0.5*p(hdom(ith))*V0^2*S*Cd
        P=V0*T*sqrt(p(0)/p(hdom(ith)));
        opmt(ith,itp,:)=[t(end),r(end,:),P]
    end
    waitbar(ith/hc,wb)
end
        
close(wb)
[pd,hd]=meshgrid(pdom,hdom);
figure(1);
subplot(2,2,1); hold on
mesh(hd/1e3,pd,opmt(:,:,2)/5280,...
    'FaceColor','interp','EdgeColor','g');
zlabel('Range, mile'); xlabel('Altitude, 1000 ft'); ylabel('Payload, # pax')
subplot(2,2,2); hold on
mesh(hd/1e3,pd,opmt(:,:,3)/1.466,...
    'FaceAlpha',0.7,'FaceColor','g','EdgeColor','none');
zlabel('Final Vel, mph'); xlabel('Altitude, 1000 ft'); ylabel('Payload, # pax')
subplot(2,2,3); hold on
mesh(hd/1e3,pd,opmt(:,:,7)/550,...
    'FaceColor','none','EdgeColor','g');
zlabel('Max Power, hp'); xlabel('Altitude, 1000 ft'); ylabel('Payload, # pax')
subplot(2,2,4); hold on
mesh(hd/1e3,pd,opmt(:,:,1)/60,...
    'FaceAlpha',0.7,'FaceColor','g','EdgeColor','none');
zlabel('Time of flight, min'); xlabel('Altitude, 1000 ft'); ylabel('Payload, # pax')
