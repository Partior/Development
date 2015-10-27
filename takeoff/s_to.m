function Prout=s_to(WS)

syms Cd Cl mu p Pa vstall W ws

S=W/ws;

vlof=1.15*vstall;
T=Pa/(0.7*vlof);
A=T/W;
B=0.5*p*S*Cl/W*(Cd/Cl-mu);
sg=vlof^2./(2*9.81*(A-B*(0.7*vlof)^2));

v2=1.25*vstall;
T2=2*Pa/(vlof+v2);
D=0.5*p*(vlof+v2)^2/4*S*Cd;
sa=W./(T2-D)*((v2^2-vlof^2)/(2*9.81)+50);

st=sg+sa;

Pr=((76735170458482661216*ws)/3125 + 1756352*((7635294564661518005389693681*ws^2)/39062500 - (1016990688499646734363883195442458641199302699096869*ws)/1099511627776000000000000000000 + 618147507827920803793197237026149416368340966109140273897615497008464383721/123794003928538027489912422400000000000000000000000000)^(1/2) + 938341888850090345589783742211387583675273/5497558138880000000000000)/(94176000000*ws);

Prout=double(subs(Pr,ws,WS))/550;