% clear;

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

airfoil_polar_file='naca0012_10.txt';  % file name of Airfoil Cl/Cd polar data as run by XFOIL
clms=[1,2,3,5]; %colums for alpha, Cl, Cd, Cm
airfoil_polar   % sets up fuselage drag

ddd=[2738;659;-2880]/26;
all=[25e3,0,0];
vint=[366,193,193];

X=zeros(2,3);
fval=zeros(1,3);

cda=@(a) Cda(0)+Cla(a)^2/(pi*0.7*10);

for itr=1:3
    cond=[ddd(itr);p(all(itr));vint(itr)];
    [x(:,itr),fval(itr),~,ot(itr)]=fmincon(@(x) func(x,CDA,cond),[0,40,0],[],[],[],[],...
        [-1,0,0],[1,100,10],@(x) funccon(x,CLA,cond),optimoptions('fmincon','display','none'));
end

xx=[x;fval]
