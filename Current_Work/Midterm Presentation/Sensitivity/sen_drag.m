%% Calculate changes in fuel consumption for chagnes in Drag
% 
% 
dD=[-flipud(dD);dD];    %make negitive and positive
gmD=zeros(size(dD));
for itr=1:length(dD)
    D_cr=D_cr0+dD(itr);
    P_cr=fsolve(@(pp) T(v,h,0,2)*pp-D_cr0,0.5,optimoptions('fsolve','display','off'))*340*2;
    gmD(itr)=gmma(v,P_cr);
end