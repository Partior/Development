%% New Version of V-H
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions
pdom=[0.5:0.1:1];

aoafind=@(v,h) fzero(@(a) L(a,h,v,2)-W0(19),[Cl0-incd Clmax-incd]);


cont=true;
itr=1;
stp=100;
tolx=4e-3;
maxstp=2e3;
hr=0;
h=0;
vst=fzero(@(v) L(Clmax-incd,h,v,2)-W0(19),[50 500]);
vmd=fminbnd(@(v) D(aoafind(v,h),h,v,2),vst,500,optimset('TolX',1e-3,'TolFun',1e-3));
m(itr)=fsolve(@(mt) D(aoafind(mt*a(h),h),h,mt*a(h),2)-Tc(mt*a(h),h),vst/a(h)+0.005,optimoptions('fsolve','display','off'));
m2(itr)=fsolve(@(mt) D(aoafind(mt*a(h),h),h,mt*a(h),2)-Tc(mt*a(h),h),0.7,optimoptions('fsolve','display','off'));
itr=itr+1;
itr2=2;
hr(itr)=hr(itr-1)+stp;

while cont
    h=hr(itr);
    vst=fzero(@(v) L(Clmax-incd,h,v,2)-W0(19),[50 500]);
    vmd=fminbnd(@(v) D(aoafind(v,h),h,v,2),vst,500,optimset('TolX',1e-3,'TolFun',1e-3));
    
    if Tc(vmd,h)<D(aoafind(vmd,h),h,vmd,2)
        if stp<5
            cont=false;
        else
            stp=stp/2
        end
    else
        m(itr)=fsolve(@(mt) D(aoafind(mt*a(h),h),h,mt*a(h),2)-Tc(mt*a(h),h),vst/a(h)+0.005,optimoptions('fsolve','display','off'));
        m2(itr)=fsolve(@(mt) D(aoafind(mt*a(h),h),h,mt*a(h),2)-Tc(mt*a(h),h),0.7,optimoptions('fsolve','display','off'));
        plot(a2,m(itr),h,'k.',m2(itr),h,'k.')
        drawnow
        itr=itr+1;
        if abs(diff([m(itr-1),m2(itr-1)]))<tolx
            itr=itr-1;
            stp=stp/2;
        elseif itr~=1 && abs(diff([m(itr-1),m(itr-2)]))<tolx
            stp=min([stp*2;maxstp]);
        end
    end
    
    hr(itr)=hr(itr-1)+stp;
    itr2=itr2+2;
    plot(a1,itr2,stp,'k.')
end

