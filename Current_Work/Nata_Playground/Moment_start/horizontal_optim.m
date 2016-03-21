clear;

prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h
airfoil_polar   % sets up fuselage drag

ddd=[2732;-3500;-8936]/26;
all=[25e3,0,0];
vint=[366,193,193];

X=zeros(2,3);
fval=zeros(1,3);

for itr=1:3
    cond=[ddd(itr);p(all(itr));vint(itr)];
    [x(:,itr),fval(itr),~,ot(itr)]=fmincon(@(x) func(x,Cda,cond),[0,40],[],[],[],[],...
        [-6,0],[12,100],@(x) funccon(x,Cla,cond),optimoptions('fmincon','display','none'));
end

xx=[x;fval];
