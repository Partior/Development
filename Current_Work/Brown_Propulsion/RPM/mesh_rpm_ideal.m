

resol=20;
he=0;


ops=optimoptions('fmincon','Display','off');
lb=1000; ub=2500;
rndpnts=8; % number location starts;
rpm_spec=linspace(lb,ub,rndpnts);
[vmat,tmat]=meshgrid(linspace(0,500,resol),linspace(0,1e3,resol));

idd=zeros(resol);
ppp=zeros(resol);

for ita=1:resol
    waitbar((ita-1)/resol)
    for itb=1:resol
        ve=vmat(ita,itb); te=tmat(ita,itb);
        var={ve;he;Cr_T};
        cont=true;
        while cont
            parfor itr=1:rndpnts
                [x(itr),fval(itr),ef(itr)]=...
                    fmincon(@(x) Cr_P(ve,he,x),rpm_spec(itr),[],[],[],[],lb,ub,@(w) tr(w,te,var),ops);
                if ef(itr)<=0
                    fval(itr)=NaN;
                end
            end
            [~,nn]=min(fval);
            if ef(nn)<=0
                if rndpnts>25
                    rpm_ideal=NaN;
                    cont=false;
                end
                rndpnts=rndpnts+8;
                rpm_spec=linspace(lb,ub,rndpnts);
            else
                rpm_ideal=x(nn);
                cont=false;
            end
        end
        idd(ita,itb)=rpm_ideal;
        ppp(ita,itb)=Cr_P(ve,he,rpm_ideal)/550;
    end
end
waitbar(1)

idd2=interp2(idd,2,'cubic');
idd2(idd2==idd2(end,end))=NaN;
idd2(idd2<=lb+1)=NaN;
mesh(interp2(vmat,2,'cubic')/1.4666,interp2(tmat,2,'cubic'),idd2,...
    interp2(ppp,2,'cubic'),'EdgeColor',[0.8 0.8 0.8],'FaceColor','flat')
xlabel('Vel, mph')
ylabel('Thrust, lbf')
zlabel('RPM')
title('Optimum RPM for Min SHP')
caxis([0 350])
cbc=colorbar;
cbc.Label.String='Shaft Horse Power';