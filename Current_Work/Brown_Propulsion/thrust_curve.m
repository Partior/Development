%% Thrust Curve
% AS OF 29 FEB
curve_read

% cruise thrust
Cr_T=@(V,h,n) C_Tc(j_ratio(V,n,Rmax(1)))*p(h).*(n/60).^2*(2*Rmax(1))^4;
% Takeoff thrust
Tk_T=@(V,h,n) C_Tt(j_ratio(V,n,Rmax(2)))*p(h).*(n/60).^2*(2*Rmax(2))^4;

% Power Coefficient
Cr_P=@(V,h,n) C_Pc(j_ratio(V,n,Rmax(1)))*p(h).*(n/60).^3*(2*Rmax(1))^5;
Tk_P=@(V,h,n) C_Pt(j_ratio(V,n,Rmax(2)))*p(h).*(n/60).^3*(2*Rmax(2))^5;


rpm_curves