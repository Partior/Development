%% Incident Angle Comparing to number of engines

%%
clear; clc
prop_const

%% Constants
h=25e3;
v=366;  %250mph
ndom=2:2:12;
incdd=linspace(-1,10,20);
[nmsh,incm]=meshgrid(ndom,incdd);

gmm=@(v,P) v/SFC_eq(P/550)/5280;

var=    'S'  ;
resol=  30      ;
dstart= 150     ;
dend=   400       ;
varince=linspace(dstart,dend,resol);

%% Domain
wb=waitbar(0,'Moving......');
for itr=1:length(ndom)
    n=ndom(itr)
    ne=ndom(itr);
    for itb=1:20
        waitbar(itb/20,wb)
        incd=incdd(itb);
        for ita=1:resol
            % Variable Assignment
            S=varince(ita);
            
            % Prop Specific
            prop_T
            v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h
            % Airfoil_specific
            airfoil_polar   % sets up fuselage drag
            cd_new      % sets up airfoil and fueslage drag polar
            % Force Speciic
            equations_wash  % sets up lift and drag functions
            
            AA=fsolve(@(rr) L(rr,h,v,ne)-W0(19),0,optimoptions('fsolve','display','off'));
            
            % Assign Value
            plvl(ita)=D(AA,h,v,ne)/(T(v,h,Pa/n)*ne);
            gmma(ita)=gmm(v,plvl(ita)*Pa*ne/n);
        end
        [~,ci]=max(plvl./gmma);
        tdt(itb,itr)=varince(ci);
        tdt2(itb,itr)=plvl(ci);
        tdt3(itb,itr)=gmma(ci);
    end
end
close(wb)

%%
[pretn,preti]=meshgrid(linspace(ndom(1),ndom(end)),linspace(incdd(1),incdd(end)));
pretvar=interp2(nmsh,incm,tdt,pretn,preti,'spline');
figure(1); clf
ax(1)=gca;
mesh(pretn,preti,pretvar)
xlabel('Engines')
ylabel('Incd Angle')
zlabel(var)

pretpl=interp2(nmsh,incm,tdt2,pretn,preti,'spline');
figure(2); clf
ax(2)=gca;
contour(pretn,preti,pretpl)
xlabel('Engines')
ylabel('Incd Angle')
title('Power')
colorbar
zlim([0 2])

pretgm=interp2(nmsh,incm,tdt3,pretn,preti,'spline');
figure(3); clf
ax(3)=gca;
contour(pretn,preti,pretgm)
xlabel('Engines')
ylabel('Incd Angle')
title('Fuel')
colorbar
zlim([0 2])
