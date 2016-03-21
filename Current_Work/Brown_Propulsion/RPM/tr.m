function [c,ceq] = tr(w,T,var)

ve=var{1};
he=var{2};
Cr_T=var{3};

c=T-Cr_T(ve,he,w);
ceq=[];

end

