function plvl=vh_det(h,v)

load('../constants.mat')

exP=@(h,v,n,pl) (pl*Pa*sqrt(p(h)/p(0))-...
    (0.5*v.^3.*p(h)*S*Cd0+K*n.^2*W0(19)^2./(0.5*v.*p(h)*S)));

lh=length(h);
lv=length(v);
plvl=zeros(lh,lv);
for ita=1:lh
    for itb=1:lv
        try
            plvl(ita,itb)=fzero(@(pl) exP(h(ita),v(itb),1,pl),[0 2]);
        catch
            plvl(ita,itb)=NaN;
        end
    end
end