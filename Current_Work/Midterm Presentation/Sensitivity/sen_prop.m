%% Calculate changes in fuel consumption for chagnes in propeller eff
% 
% 
gmN=zeros(size(dNp));
for itr=1:length(dNp)
    gmN(itr)=gmma(v,P_cr0/dNp(itr)*Np0);
end