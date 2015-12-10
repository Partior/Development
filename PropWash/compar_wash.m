%% Comparator

% Compares various ariplane parameters to chosen cruise conditions

%% Init
% run scripts to initalize variables
clear; clc
prop_const

%% Constants
h=25e3;
v=366;  %250mph
ne=n;   % running engines

gmm=@(v,P) v/SFC_eq(P/550)/5280;

%% Domain
var=    'S'  ;
resol=  30      ;
dstart= 200     ;
dend=   350       ;

varince=linspace(dstart,dend,resol);

for itr=1:resol
    % Variable Assignment
    eval([var,'=',num2str(varince(itr)),';']);
 
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
    plvl(itr)=D(AA,h,v,ne)/(T(v,h,Pa/n)*ne);
    gmma(itr)=gmm(v,plvl(itr)*Pa*ne/n);
end

%% Plotting
figure(1); clf

plotyy(varince,plvl*100,varince,gmma)
xlabel(var)
legend({'Power Level','Fuel Efficiency'})
gf=gcf;
gf.Children(2).YLabel.String='lbs per mile';
gf.Children(3).YLabel.String='% Throttle';

figure(2); clf; hold on
plot(varince,gmma./plvl,'g')
[~,nn]=max(gmma);
plot(varince(nn),gmma(nn)./plvl(nn),'b*')
[~,np]=min(plvl);
plot(varince(np),gmma(np)./plvl(np),'r*')
[~,nt]=max(gmma./plvl);
plot(varince(nt),gmma(nt)./plvl(nt),'g*')
xlabel(var)
ylabel('Fuel Per Power')