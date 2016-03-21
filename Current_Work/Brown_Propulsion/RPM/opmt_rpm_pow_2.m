%% Find optimum RPM for required thrust curves

% ve=250;

% te=100;



cont=true;
while cont
    clear fval x ef
    for itr=1:rndpnts
        [x(itr),fval(itr),ef(itr)]=...
            fmincon(@(x) Cr_P(ve,he,x),rpm_spec(itr),[],[],[],[],lb,ub,@(w) tr(w,te,var),ops);
        if ef<=0
            fval(itr)=NaN;
        end
    end
    [~,nn]=min(fval);
    if ef(nn)<=0
        rndpnts=rndpnts+10;
        rpm_spec=linspace(lb,ub,rndpnts);
    else
        cont=false;
    end
end

rpm_ideal=x(nn);