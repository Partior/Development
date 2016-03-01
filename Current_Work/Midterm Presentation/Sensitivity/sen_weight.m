%% Calculate changes in fuel consumption for chagnes in weight
% 
% 
dW=[-flipud(dW);dW];    %make negitive and positive
gmW=zeros(size(dW));
for itr=1:length(dW)
    taoa=fsolve(@(rr) L(rr,h,v,ne)-W0(19),0,optimoptions('fsolve','display','off'));
    D_cr=D(taoa,h,v,ne);
    P_cr=fsolve(@(pp) T(v,h,0,2)*pp-D_cr0,0.5,optimoptions('fsolve','display','off'))*340*2;
    gmW(itr)=gmma(v,P_cr);
end