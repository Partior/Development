%% Conditional Function for Descent Fmincon
function [c,ceq]=cond_desc(X,v)

ceq=[];

al=X(1);
pow=X(2);
gm=v{1};
h=v{2};
vel=v{3};
L=v{4};
D=v{5};
W_Descent=v{6};
package=v{7};
Cr_T=v{8};

c(1,1)=-cosd(gm)*L(al,h,vel,2)+W_Descent+...
    sind(gm)*(2*Cr_T(vel,h,opmt_rpm_pow(vel,h,package,1,pow))-...
    D(al,h,vel,2));
c(2,1)=-sind(gm)*L(al,h,vel,2)-cosd(gm)*(2*Cr_T(vel,h,opmt_rpm_pow(vel,h,package,1,pow))-...
    D(al,h,vel,2));