%% Velocity and Thrust to Dynamic Pressure Ratio
% Looks at free stream velocity and operating Thrust to output velocity
% over the wing

clear; clc
load('../ConceptCompar/constants.mat')
prop_T

%% Domains
mdom=linspace(0,0.6);   % mach speeds
plvl=linspace(0.6,1);   % power levels
hdom=linspace(0,30e3);

[msh,psh]=meshgrid(mdom,plvl);
[~,hsh]=meshgrid(mdom,hdom);


v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);
%% Mesh Calculations
for ita=1:100
    for itb=1:100
        vint=msh(ita,itb)*a(0);
        hint=hsh(ita,itb);
        vpl(ita,itb)=v2(vint,psh(ita,itb)*T(vint),0);
        vh(ita,itb)=v2(vint,T(vint)*sqrt(p(hint)/p(0)),hint);
    end
end
% 
% %% Plotting
% if strcmp(input('Plot? y/n: ','s'),'y')
%     figure(1); clf
%     mesh(msh,psh,vpl.^2./(msh*a(0)).^2)
%     set(gca,'ZScale','log')
%     
%     xlabel('Mach')
%     ylabel('P_{lvl}')
%     zlabel('q_2/q_1')
%     title(sprintf('R=%0.2fft n=%g Pa=%ghp',Rmax,n,Pa/550))
%     
%     figure(2); clf
%     mesh(msh,hsh/1e3,vh.^2./(msh.*a(hsh)).^2)
%     set(gca,'ZScale','log')
%     
%     xlabel('Mach')
%     ylabel('Alt, 1,000 ft')
%     zlabel('q_2/q_1')
%     title(sprintf('R=%0.2fft n=%g Pa=%ghp',Rmax,n,Pa/550)) 
% end