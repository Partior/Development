function [c,ceq]=roc_con(X,varargin)

ceq=[];

v=X(1);
p=X(2);

h=varargin{1};
xtra=varargin{2};
L=xtra{1};
W=xtra{2};
D=xtra{3};
Tc=xtra{4};

c(1)=D(fsolve(@(aa) L(aa,h,v,2)-W,5,optimoptions('display','off')),h,v,2)-...
    Tc(v,h);