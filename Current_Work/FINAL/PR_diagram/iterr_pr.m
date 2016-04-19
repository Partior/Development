function [dval]=iterr_pr(t,d,payload,xsol)

persistent ne L D SFC_eq W0 Wf Cr_P Cr_T
if t==0
    load('FINAL/PR_diagram/pr_const.mat')
end

v=xsol(1);
h=xsol(2);

dval=zeros(size(d));
WC=d(1)-Wf+W0(19)+payload;
taoa=fsolve(@(rr) L(rr,h,v,ne)-WC,0,optimoptions('fsolve','display','off'));
D_cr=D(taoa,h,v,ne);
rpr=fsolve(@(rr) 2*Cr_T(v,h,rr)-D_cr,2000,optimoptions('fsolve','display','off'));
dval(1)=-SFC_eq(Cr_P(v,h,rpr)/550*2);