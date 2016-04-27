%% Drag Polar at Cruise and Takeoff

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

clear vdom
vdom=linspace(200,600)';

% %Cruise
airfoil_polar_file='Fullplane polar.txt';
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash  % sets up lift and drag functions
LFUS=@(rr,v) 0.5*p(25e3)*Cla(rr)*v^2*S;
DFUS=@(rr,v) 0.5*p(25e3)*Cda(rr)*v^2*S;

airfoil_polar_file='Q1fullpolar.txt';
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash  % sets up lift and drag functions
LWNG=@(rr,v) Lw(rr,25e3,v,2);
DWNG=@(rr,v) Dw(rr,25e3,v,2);

airfoil_polar_file='horizontal tail cruise.txt';
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar
equations_wash  % sets up lift and drag functions
LHOR=@(rr,v) 0.5*p(25e3)*Cla(rr)*v^2*25;
DHOR=@(rr,v) 0.5*p(25e3)*Cda(rr)*v^2*25;

DVER=@(rr,v) 0.5*p(25e3)*0.005085*v^2*27;

clear D_rec P_rec

for itr=1:100
    [rr,~,flg,~]=fsolve(@(rr) mean([LWNG(rr,vdom(itr)),LFUS(rr,vdom(itr))])+LHOR(rr,vdom(itr))-W0(17),...
        1,optimoptions('fsolve','display','off'));
    P_rec(itr,1)=Tc(vdom(itr),25e3);
    if flg<1
        D_rec(itr,:)=NaN(1,2);
    else
        D_rec(itr,:)=[mean([DFUS(rr,vdom(itr)),DWNG(rr,vdom(itr))]);
            DHOR(rr,vdom(itr))+DVER(rr,vdom(itr))]';
    end
end

clf
plot(vdom/1.46666,(P_rec*0.9-sum(D_rec,2)).*vdom/550)
hold on
plot(vdom/1.46666,sum(D_rec,2)*1.5)
plot(vdom/1.46666,D_rec(:,2)*2)

ind=find((P_rec*0.9-sum(D_rec,2))<0,1,'first');

y2=ylim;
x2=xlim;
xlim([x2(1) 10.25*round(vdom(ind)/14.66666)])
ylim([0 y2(2)])
xlabel('Cruise Velocity, mph')
title('Aerodynamic Performance at Cruise')
legend({'Excess Power, hp';'Total Drag, lbf';'Empanage Drag, lbf'})
