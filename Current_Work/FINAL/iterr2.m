function [dval]=iterr(t,d,fv)

cl=who;
persistent v h ne L D Cr_T SFC_eq W0 Wf Cr_P
if length(cl)<4
    ne=2;
    L=fv{1};
    Cr_T=fv{2};
    D=fv{3};
    SFC_eq=fv{4};
    W0=fv{5};
    Wf=fv{6};
    Cr_P=fv{7};
end

X=fv{8};
v=X(1);
h=X(2);

dval=zeros(size(d));
WC=d(1)+W0(19)-Wf;
taoa=fsolve(@(rr) L(rr,h,v,ne)-WC,0,optimoptions('fsolve','display','off'));
D_cr=D(taoa,h,v,ne);
P_cr=fsolve(@(pp) 2*Cr_T(v,h,opmt_rpm_pow(v,h,{Cr_P,1},1,pp))-D_cr,0.8,optimoptions('fsolve','display','off'));
dval(1)=-SFC_eq(P_cr*2);