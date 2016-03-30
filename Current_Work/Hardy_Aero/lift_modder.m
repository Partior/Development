modificationCL=0.3;

Lf=@(aoa,h,v) 1/2*p(h)*v.^2*Cla(aoa+Cl0)*(S)*0.2; % Approximation for Fuselage lift
Lw=@(aoa,h,v,on) ...
    1/2*p(h)*v.^2*Cla(aoa+incd)*...
    (S-2*((on-2)/2>=[0,1,2,3])*s_a)+...free stream wing lift
    1/2*p(h)*v2(v,CT(v,h,on),h,1).^2*(Cla(ang(v,h,1,on)*aoa+incd)+modificationCL)*(2*s_a(1))+... prop wash lift, cruise props
    1/2*p(h)*v2(v,TT(v,h,on),h,2).^2*(Cla(ang(v,h,2,on)*aoa+incd)+modificationCL)*...
    (2*((on-2)/2>=[1,2,3])*s_a(2:4));  %prop wash lift, takeoff props
L=@(aoa,h,v,on) Lf(aoa,h,v)+Lw(aoa,h,v,on);