%% Numerical Output for Performance
% Using the results from V-H envelope, output the following:
% 
% ABSOLUTES
% Max Mach
%   Max Mach Altitude
% Max Speed
%   Max Speed Altitude
% Service Ceiling
% Max N-Turn
% Stall Speed @ Sea Level
% 
% CRUISE CONDITIONS
% Fuel Efficency
% Power Level
% 
% CRUISE ALTITUDE
% Stall Speed
% Max Cruise
% Max Fuel Efficiency
%   Speed of Max Fuel Efficiency

clc
fprintf('\nOutput for Performance - \n\n')
%% Absolutes
fprintf('\n\tABSOLUTES: \n')
% Service Ceiling
pclmb=100/60;
plvlclmb=(Pa/W0(19)-pclmb)/(Pa/W0(19));
ntn=hnp.ContourMatrix;
ind=find(ntn(1,:)==1);
ind2=find(ntn(1,:)==2);
nturn=ntn(:,ind+1:ind2-1);
ntnl=pchip(nturn(1,:),nturn(2,:));
ppl=griddedInterpolant({linspace(0,52e3,resol),linspace(0.1,0.6,resol)},pl);
if ppl(nturn(2,1)*1e3,nturn(1,1))-plvlclmb<0
    scsc=max(nturn(2,:))*1e3;
else
    ms=fzero(@(m) ppl(ppval(ntnl,m)*1e3,m)-plvlclmb,nturn(1,[1,end]),optimoptions('fsolve','Display','none'));
    scsc=ppval(ntnl,ms)*1e3;
end
fprintf('\t\t%20s %7.0f    ft \n','Service Ceiling',scsc)
% Max Mach
pll=h_m.ContourMatrix;
ind=find(pll(1,:)==100);
mxp=pll(:,ind+1:end);
[mx_mc,ind]=max(mxp(1,:));
fprintf('\t\t%20s %10.2f Mach \n','Max Mach',mx_mc)
fprintf('\t\t%20s %7.0f    ft \n','Max Mach Alt',mxp(2,ind)*1e3)
% Max Speed
[mx_sp,ind]=max(mxp(1,:).*a(mxp(2,:)*1e3));
fprintf('\t\t%20s %10.2f mph \n','Max Speed',mx_sp/1.4666)
fprintf('\t\t%20s %7.0f    ft \n','Max Speed Alt',mxp(2,ind)*1e3)
% Max N Turn
n_t2=n_t; n_t2(pl>1)=0;
[ri,ci]=find(n_t2==max(max(n_t2)));
fprintf('\t\t%20s %10.2f g \n','Max N-Turn',n_t(ri,ci))
% Stall Speed @ Sea Level
[~,nn]=min(nturn(2,:));
fprintf('\t\t%20s %10.2f mph \n','Stall Speed',nturn(1,nn)*a(nturn(2,nn))/1.4666)

%% Cruise Conditions
fprintf('\n\tCRUISE CONDITIONS: \n')
fprintf('\t 250 mph, 25e3 ft \n')
% Fuel Efficiency
gml=griddedInterpolant({linspace(0,52e3,resol),linspace(0.1,0.6,resol)},gm);
fprintf('\t\t%20s %10.2f m/lb \n','Fuel Efficiency',gml(25e3,366/a(25e3))/5280)
% Power Level
fprintf('\t\t%20s %10.2f %% \n','Cruise Power',ppl(25e3,366/a(25e3))*100)

%% Cruise Altitude
fprintf('\n\tCRUISE ALTITUDE: \n')
% Stall Speed
ntnl2=pchip(nturn(2,:),nturn(1,:));
fprintf('\t\t%20s %10.2f mph \n','Stall Speed',ppval(ntnl2,25)*a(25e3)/1.46666)
% Max Speed
mxpin=pchip(mxp(2,:),mxp(1,:));
fprintf('\t\t%20s %10.2f mph \n','Max Cruise',ppval(mxpin,25)*a(25e3)/1.46666)
% Max Fuel Efficiency
mxgm=fminsearch(@(m) -gml(25e3,m),0.35);
fprintf('\t\t%20s %10.2f m/lb \n','Max Fuel Eff',gml(25e3,mxgm)/5280)
% Max Fuel Efficiency speed
fprintf('\t\t%20s %10.2f mph \n','Max Fuel Eff Speed',mxgm*a(25e3)/1.4666)



