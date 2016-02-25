%% Calculate changes in fuel consumption for chagnes in Drag
% 
% 
dD=[-flipud(dD);dD];    %make negitive and positive
gmD=zeros(size(dD));
for itr=1:length(dD)
    D_cr=D_cr0+dD(itr);
    P_cr=fsolve(@(pp) T(v,h,pp,2)-D_cr,600*550,optimoptions('fsolve','display','off'))/550;
    gmD(itr)=gmma(v,P_cr);
end