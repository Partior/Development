function west3_2(AR,V_c,hc,ws)

load('constants.mat')
load('airden.mat','splinepp')
p_c=exp(ppval(splinepp,hc));
f=@(w) ((911*w.^(947/1000))/1000 + 4950)./((199517069*exp(-(R*SFC*V_c.*p_c.*(cd0 + (4*ws.^2)./(AR.*pi.*V_c.^4*e.*p_c.^2)))./(2*ws)))/200000000 - 3/50)-w;

figure(5); clf
hold on
isosurface(AR,V_c,hc,f(16e3),0)
isosurface(AR,V_c,hc,f(16.5e3),0)
isosurface(AR,V_c,hc,f(17e3),0)
