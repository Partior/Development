function [dval]=iterr(t,d,fv)

persistent v h ne L D T SFC_eq W0 Wf
if t==0
    v=250*1.4666;
    h=25e3;
    ne=2;
    L=fv{1};
    T=fv{2};
    D=fv{3};
    SFC_eq=fv{4};
    W0=fv{5};
    Wf=fv{6};
end


dval=zeros(size(d));
WC=d(1)+W0(19)-Wf;
taoa=fsolve(@(rr) L(rr,h,v,ne)-WC,0,optimoptions('fsolve','display','off'));
D_cr=D(taoa,h,v,ne);
P_cr=fsolve(@(pp) T(v,h,pp,2)-D_cr,600*550,optimoptions('fsolve','display','off'))/550;
dval(1)=-SFC_eq(P_cr);