%% Comparator

% Compares various ariplane parameters to chosen cruise conditions

%% Init
% run scripts to initalize variables
clear; clc
load('C:\Users\granata\Desktop\MATLAB Files\Partior\ConceptCompar\constants.mat')

AR=15;
S=200;
n=8;

%% Constants
h=25e3;
v=366;  %250mph
ne=6;   % running engines

%% Domain
var=    'rpm'  ;
resol=  20      ;
dstart= 1e3     ;
dend=   4e3       ;

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
    gmma(itr)=v./(SFC/3600*(D(AA,h,v,ne)));
end

%% Plotting
figure(1); clf

plotyy(varince,plvl*100,varince,gmma/5280)
xlabel(var)
legend({'Power Level','Fuel Efficiency'})