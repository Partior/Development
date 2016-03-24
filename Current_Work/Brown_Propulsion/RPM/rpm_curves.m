%% What RPM do we use?

%  What is the optimal rpm to use in various circumstances?
% Low speed, max rpm
% High speed, want max rpm or power efficiency?

% Propullsive (after SHP) Power Available: again, in fractions, that way take the number and
% multiply by the Power from the APU, and get Output Power
SHP_C=@(V,h,n) n_motor*n_Pc(j_ratio(V,n,Rmax(1)))/100;
SHP_T=@(V,h,n) n_motor*n_Pt(j_ratio(V,n,Rmax(2)))/100;

%% Optimizing RPM
    package={1;1;Rmax;1;1;Cr_P;Tk_P;n_Pc;n_Pt};