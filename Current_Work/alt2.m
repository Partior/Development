% determine the fuel efficiency at a given altitude, at 250 mph

% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h,Pa,on));

% Fuel Efficiency
gmma=@(v,P) v/SFC_eq(P)/5280;

altdom=0:5e2:37.5e3;

parfor altd=1:length(altdom)
    alt=altdom(altd);
    taoa=fsolve(@(rr) L(rr,alt,366,2)-(W0(19)-0.2*Wf),0,optimoptions('fsolve','display','off'));
    pl=plvl(taoa,alt,366,2);
    gm=gmma(366,pl*340*2/sqrt(p(alt)/p(0)));
    gml(altd)=gm;
end

plot(altdom,gml)