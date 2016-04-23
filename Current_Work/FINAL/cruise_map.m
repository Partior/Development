
hdom=linspace(18e3,35e3,20);
vdom=linspace(250,290,10)*1.4666;

for ita=1:10
    v=vdom(ita);
    parfor itb=1:20
        [t,~]=ode45(@iterr2,[0 2.5e4],Wf,...
            odeset('Events',@events_empty_fuel,'RelTol',1e-3),...
            {L,Cr_T,D,SFC_eq,W0,Wf,Cr_P,[v;hdom(itb)]});
        f(ita,itb)=t(end)*v/5280;
        g(ita,itb)=D(fzero(@(rr) L(rr,hdom(itb),v,2)-W0(19),[Cl0-incd Clmax-incd],optimoptions('fsolve','display','off')),hdom(itb),v,2)-Tc(v,hdom(itb));
    end
end
clf
contour(vdom'/1.4666,hdom',f',linspace(600,1200,20))
hold on
contour(vdom'/1.4666,hdom',g'+1000,linspace(0,20,20)+1000)