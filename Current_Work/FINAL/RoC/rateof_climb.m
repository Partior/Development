%% Rate of Climb
% Iterate through the various flap configs for RoC up to 10,000 and then no
% flaps for high climb configs
clear all; clc
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h


%% Domain
flaps={'210_30Flaps.txt';'210_20Flaps.txt';'210_10Flaps.txt';'Q1fullpolar.txt'};
hdom=linspace(0,1e4,10);
for itr=1:4
    itr
    airfoil_polar_file=flaps{itr};
    airfoil_polar   % sets up fuselage drag
    cd_new      % sets up airfoil drag polar
    equations_wash
    
    xtra={L;W0(19);D;Tc};
    parfor ht=1:length(hdom)
        h=hdom(ht)
        vmin=fzero(@(v) L(Clmax-incd,h,v,2)-W0(19),[150 330]);
        vmax=fzero(@(v) L(-15-Cl0,h,v,2)-W0(19),[250 450]);
        [X]=fmincon(@(X) D(fzero(@(aa) L(aa,h,X(1),2)-W0(19),[-15-Cl0 Clmax-incd]),h,X(1),2)-...
            2*Cr_T(X(1),h,opmt_rpm_pow(X(1),h,{Cr_P;Tk_P},1,X(2))),[mean([vmin;vmax]);300],[],[],[],[],...
            [vmin;270],[vmax;340],...
            @(X) roc_con(X,h,xtra),optimoptions('fmincon','UseParallel',false,'display','off','TolX',1e-3,'TolCon',1e-3,'TolFun',1e-3));
        roc(ht,itr)=(680-X(2))*550/W0(19)*60
    end
end

%% 