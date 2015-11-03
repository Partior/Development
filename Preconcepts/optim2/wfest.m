<<<<<<< HEAD
function wf=wfest(AR,V,p,ws)

load('constants.mat')

=======
function wf=wfest(AR,V,p,ws)

load('constants.mat')

>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
wf=53/50-(199517069*exp(-(SFC*(R + E*V)*((ws/(0.5*p*V^2))^2 + AR*pi*cd0*e))/(AR*pi*V*(ws/(0.5*p*V^2))*e)))/200000000;