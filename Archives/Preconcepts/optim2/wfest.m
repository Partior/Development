<<<<<<< HEAD
function wf=wfest(AR,V,p,ws)

load('constants.mat')

=======
function wf=wfest(AR,V,p,ws)

load('constants.mat')

>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
wf=53/50-(199517069*exp(-(SFC*(R + E*V)*((ws/(0.5*p*V^2))^2 + AR*pi*cd0*e))/(AR*pi*V*(ws/(0.5*p*V^2))*e)))/200000000;