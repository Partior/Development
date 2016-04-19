%% Rate of Climb
% Iterate through the various flap configs for RoC up to 10,000 and then no
% flaps for high climb configs
clear all; clc
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h


%% Domain
flaps={'210_30Flaps.txt';'210_20Flaps.txt';'210_10Flaps.txt';'Q1fullpolar.txt'};
hdom=linspace(0,1e4,30);
for itr=1:4
    itr
    airfoil_polar_file=flaps{itr};
    airfoil_polar   % sets up fuselage drag
    cd_new      % sets up airfoil drag polar
    equations_wash
    
    parfor ht=1:length(hdom)
        h=hdom(ht);
        vopt=fminbnd(@(v) D(Clmax-incd,h,v,2)-Tc(v,h),150,400);
        omg=fsolve(@(a) [cosd(a(2))*(Tc(vopt,h)-D(a(1),h,vopt,2))-sind(a(2))*L(a(1),h,vopt,2);
            sind(a(2))*(Tc(vopt,h)-D(a(1),h,vopt,2))+cosd(a(2))*L(a(1),h,vopt,2)-W0(19)],...
            [10;10],optimoptions('fsolve','display','off'));
        roc(ht,itr)=sind(omg(2))*vopt;
    end
end

%% 