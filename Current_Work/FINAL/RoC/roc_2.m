
hdom=linspace(0,35e3,30);
for ita=1:30
    ita
    h=hdom(ita);
    vmin=200;
    vmax=300;
    vdom(:,ita)=linspace(180,400,10)';
    parfor itr=1:10
        v=vdom(itr,ita);
        ad=fsolve(@(aa) L(aa,h,v,2)-W0(19),5,optimoptions('fsolve','display','off'));
        rd=fzero(@(r) D(ad,h,v,2)-2*Cr_T(v,h,r),1000,2500);
        pd(itr)=2*Cr_P(v,h,rd)/550;
    end
    pd(pd<0)=NaN;
    pdd(:,ita)=pd;
end
roc=(680-pdd)*550/W0(19)*60;
plot(hdom,max(roc))