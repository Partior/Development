nm='naca0012';
ftyp='.txt';
mod1={'_n10';'_n5';'';'_5';'_10'};
mod2={'';'_6'};

a1=-6:0.5:6;

for xloc=1:2
    for flp=1:5
        polar=[nm,mod1{flp},mod2{xloc},ftyp];
        if flp==3 && xloc==2
            polar='naca0012.txt';
        end
        dta=importdata(polar);
        in2=size(dta.data(:,1),1);
        a0=dta.data(:,1);
        cla(:,flp,xloc)=interp1(a0,dta.data(:,2),a1,'linear','extrap');
        cda(:,flp,xloc)=interp1(a0,dta.data(:,3),a1,'linear','extrap');
    end
end

[df,aa]=meshgrid(-10:5:10,a1);
[df2,aa2]=meshgrid(-10:10,a1);

cla2(:,:,1)=interp2(df,aa,cla(:,:,1),df2,aa2,'spline');
cla2(:,:,2)=interp2(df,aa,cla(:,:,2),df2,aa2,'spline');
cda2(:,:,1)=interp2(df,aa,cda(:,:,1),df2,aa2,'spline');
cda2(:,:,2)=interp2(df,aa,cda(:,:,2),df2,aa2,'spline');

figure
mesh(df2,aa2,cla2(:,:,1))
title('C_L, 0.8 flap')
xlabel('\delta_f')
ylabel('\alpha')
zlabel('C_l')

figure
mesh(df2,aa2,cda2(:,:,1))
title('C_D, 0.8 flap')
xlabel('\delta_f')
ylabel('\alpha')
zlabel('C_d')

figure
mesh(df2,aa2,cla2(:,:,2))
title('C_L, 0.6 flap')
xlabel('\delta_f')
ylabel('\alpha')
zlabel('C_l')

figure
mesh(df2,aa2,cda2(:,:,2))
title('C_D, 0.6 flap')
xlabel('\delta_f')
ylabel('\alpha')
zlabel('C_d')