<<<<<<< HEAD
function wt=west3(AR,V,p,ws)

load('constants.mat');
wt=fsolve(@(w) ((911*w.^(947/1000))/1000 + 4950)./((199517069*exp(-(R*SFC*V*p*(cd0 + (4*ws.^2)./(AR*pi*V^4*e*p^2)))./(2*ws)))/200000000 - 3/50)-w,...
    15e3,optimoptions('fsolve','Display','none'));


=======
function wt=west3(AR,V,p,ws)

load('constants.mat');
wt=fsolve(@(w) ((911*w.^(947/1000))/1000 + 4950)./((199517069*exp(-(R*SFC*V*p*(cd0 + (4*ws.^2)./(AR*pi*V^4*e*p^2)))./(2*ws)))/200000000 - 3/50)-w,...
    15e3,optimoptions('fsolve','Display','none'));


>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
