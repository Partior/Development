%% Comparator

% Compares various ariplane parameters to chosen cruise conditions

%% Init
% run scripts to initalize variables
clear; clc
prop_const
n=12;

    % Prop Specific
    prop_T
    v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
    % Airfoil_specific
    airfoil_polar   % sets up fuselage drag
    cd_new      % sets up airfoil and fueslage drag polar
%% Constants
h=28e3;
v=366;  %250mph
ne=n;   % running engines

gmm=@(v,P) v/SFC_eq(P)/5280;

%% Domain
var=    'S'  ;
resol=  20      ;
dstart= 200    ;
dend=   300       ;

varince=linspace(dstart,dend,resol);

for itr=1:resol
    % Variable Assignment
    eval([var,'=',num2str(varince(itr)),';']);
    ne=n;
 
%     % Prop Specific
%     prop_T
%     v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

%     % Airfoil_specific
%     airfoil_polar   % sets up fuselage drag
%     cd_new      % sets up airfoil and fueslage drag polar

    % Force Specific
    equations_wash  % sets up lift and drag functions
    
    v_md=fminbnd(@(vt) D(fsolve(@(rr) L(rr,h,vt,2)-W0(19),0,optimoptions('fsolve','display','off')),h,vt,2),150,450);
    
    plvl(itr)=fsolve(@(pp) 2*Cr_T(v_md,h,opmt_rpm_pow(v_md,h,{Cr_P,1},1,pp))-...
        D(fsolve(@(rr) L(rr,h,v_md,2)-W0(19),0,optimoptions('fsolve','display','off')),h,v_md,2),300,optimoptions('fsolve','display','off'));
    gmma(itr)=gmm(v_md,plvl(itr)*2);
    
    % Assign Value
%     plvl(itr)=D(AA,h,v,2)/(T(v,h,0,2));
%     gmma(itr)=gmm(v,plvl(itr)*340*2);
    clear functions
    [t,fl]=ode45(@iterr,[0 2.5e4],Wf,...
    odeset('Events',@events_empty_fuel,'RelTol',1e-6),...
    {L,Cr_T,D,SFC_eq,W0,Wf,Cr_P});
    
    r(itr)=t(end)*250*1.4666/5280;
end

%% Plotting
figure(1); clf

plotyy(varince,r,varince,[gmma',plvl'/340])
xlabel(var)
legend({'Range';'Initial \gamma';'Inital Power Level'})
gf=gcf;
gf.Children(2).YLabel.String='Miles range';
gf.Children(2).YLabel.String='Miles per lb_{fuel}';

figure(2); clf; hold on
plot(varince,gmma./plvl,'g')
[~,nn]=max(gmma);
plot(varince(nn),gmma(nn)./plvl(nn),'b*')
[~,np]=min(plvl);
plot(varince(np),gmma(np)./plvl(np),'r*')
[~,nt]=max(gmma./plvl);
plot(varince(nt),gmma(nt)./plvl(nt),'k*')
xlabel(var)
ylabel('Fuel Per Power')

fprintf('Optimum at: %s = %g \n',var,varince(nt))