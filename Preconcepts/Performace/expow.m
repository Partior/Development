<<<<<<< HEAD
function n=expow(V,h)

parm
WTO=@(px) We+Wf+225*(3+px);
ph=p_sl*exp(-3.24e-05*h);
Pa=P*550*sqrt(ph/p_sl);
K=1/(e*pi*AR);
Cd0=0.022;
dhdt=0;
dvdt=0;
g=32.2;
q=0.5*ph*V.^2;
n=(S^(1/2)*q.^(1/2).*(Pa*g-V*WTO(19)*dvdt-WTO(19)*dhdt*g-Cd0*S*V*g.*q).^(1/2))./...
    (K^(1/2)*V.^(1/2)*WTO(19)*g^(1/2));

n=real(n);
=======
function n=expow(V,h)

parm
WTO=@(px) We+Wf+225*(3+px);
ph=p_sl*exp(-3.24e-05*h);
Pa=P*550*sqrt(ph/p_sl);
K=1/(e*pi*AR);
Cd0=0.022;
dhdt=0;
dvdt=0;
g=32.2;
q=0.5*ph*V.^2;
n=(S^(1/2)*q.^(1/2).*(Pa*g-V*WTO(19)*dvdt-WTO(19)*dhdt*g-Cd0*S*V*g.*q).^(1/2))./...
    (K^(1/2)*V.^(1/2)*WTO(19)*g^(1/2));

n=real(n);
>>>>>>> c95d0c656b92fc28985e433b06102151be39b9c5
