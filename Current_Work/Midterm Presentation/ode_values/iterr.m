function [dval]=iterr(t,d,fv)

cl=who;
persistent v h ne L D Tc SFC_eq W0 Wf
if length(cl)<4
    v=250*1.4666;
    h=25e3;
    ne=2;
    L=fv{1};
    Tc=fv{2};
    D=fv{3};
    SFC_eq=fv{4};
    W0=fv{5};
    Wf=fv{6};
end


dval=zeros(size(d));
WC=d(1)+W0(19)-Wf;
taoa=fsolve(@(rr) L(rr,h,v,ne)-WC,0,optimoptions('fsolve','display','off'));
D_cr=D(taoa,h,v,ne);
P_cr=fsolve(@(pp) Tc(v,h)*pp-D_cr,0.8,optimoptions('fsolve','display','off'));
dval(1)=-SFC_eq(P_cr*340*2);