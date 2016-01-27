%% Study on Power of props to number of props
figure(3);
subplot(2,2,1); cla; hold on
subplot(2,2,2); cla; hold on
subplot(2,2,3:4); cla; hold on

clear; clc
load('C:\Users\granata\Desktop\MATLAB Files\Partior\ConceptCompar\constants.mat')

AR=15;
S=200;
n=8;

prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor


%% Domain and Constants
propss=550*[125,125,125,125;
    250,125,125,0;
    300,100,100,0;
    250,250,0,0;
    400,100,0,0;
    500,0,0,0];

R_props=[Rmax,Rmax,Rmax,Rmax];
alim=[-12-Cl0 13-incd];    %limits on AoA
adom=linspace(alim(1),alim(2),40);

sz=size(propss);

v=100;
h=1e3;

%% Control
props_c=[];
itr=1;
for ita=1:40
    aoa=adom(ita);
    Ls(ita)=1/2*p(h)*v^2*Cla(aoa+Cl0)*(S)*0.2+...
        1/2*p(h)*v^2*Cla(aoa+incd)*((b-4*sum(R_props))*chrd);
    Ds(ita)=Df(adom(ita),h,v)+...
        1/2*p(h)*v^2*Cda(aoa+incd)*((b-4*sum(R_props))*chrd);
    for ppp=1:4
        if propss(itr,ppp)==0
            Ls(ita)=Ls(ita)+1/2*p(h)*v^2*Cla(aoa+incd)*((4*R_props(ppp))*chrd);
            Ds(ita)=Ds(ita)+1/2*p(h)*v^2*Cda(aoa+incd)*((4*R_props(ppp))*chrd);
        else
            Ls(ita)=Ls(ita)+...
                1/2*p(h)*v2(v,T(v,h,propss(itr,ppp)),h)^2*Cla(aoa*ang(v,h)+incd)*(4*R_props(ppp)*chrd);
            Ds(ita)=Ds(ita)+...
                1/2*p(h)*v2(v,T(v,h,propss(itr,ppp)),h)^2*Cda(aoa*ang(v,h)+incd)*(4*R_props(ppp)*chrd);
        end
    end
end
LCON=Ls; DCON=Ds;

%% Calculations

for itr=1:sz(1)
    for ita=1:40
        aoa=adom(ita);
        Ls(ita)=1/2*p(h)*v^2*Cla(aoa+Cl0)*(S)*0.2+...
            1/2*p(h)*v^2*Cla(aoa+incd)*((b-4*sum(R_props))*chrd);
        Ds(ita)=Df(adom(ita),h,v)+...
            1/2*p(h)*v^2*Cda(aoa+incd)*((b-4*sum(R_props))*chrd);
        for ppp=1:4
            if propss(itr,ppp)==0
                Ls(ita)=Ls(ita)+1/2*p(h)*v^2*Cla(aoa+incd)*((4*R_props(ppp))*chrd);
                Ds(ita)=Ds(ita)+1/2*p(h)*v^2*Cda(aoa+incd)*((4*R_props(ppp))*chrd);
            else
                Ls(ita)=Ls(ita)+...
                    1/2*p(h)*v2(v,T(v,h,propss(itr,ppp)),h)^2*Cla(aoa*ang(v,h)+incd)*(4*R_props(ppp)*chrd);
                Ds(ita)=Ds(ita)+...
                    1/2*p(h)*v2(v,T(v,h,propss(itr,ppp)),h)^2*Cda(aoa*ang(v,h)+incd)*(4*R_props(ppp)*chrd);
            end
        end
    end
    LD=Ls./Ds-LCON./DCON;
    Ls=Ls-LCON;
    Ds=Ds-DCON;
    subplot(2,2,1)
    plot(adom,Ls)
    text(adom(end)+itr/10,Ls(end),num2str(itr))
    subplot(2,2,2)
    plot(adom,Ds)
    text(adom(end)+itr/10,Ds(end),num2str(itr))
    subplot(2,2,3:4)
    plot(adom,LD)
    text(adom(1)+itr/10,LD(1),num2str(itr))
end

%%
beep
