function dv=landing_ode(t,y)

load('land_const.mat')
dv=zeros(size(y));

% Moments on Craft
if y(2)<-3.78
    dv(2)=0;
else
    dv(2)=-II/CM(y(1),y(4));
    if dv(2)>0;
        dv(2)=-0.125;
    end
end

if y(1)<0
    y(1)=0;
    dv(1)=0;
else
    dv(1)=y(2);
end

% When do we start braking
if y(1)<0.25
    dv(4)=-D(y(1),5000,y(4),0)/(WLAND/32.2)-32.2*(muTire+0.02)*(1-L(y(1),5000,y(4),2)/WLAND);
else
    dv(4)=-D(y(1),5000,y(4),0)/(WLAND/32.2)-32.2*0.02*(1-L(y(1),5000,y(4),2)/WLAND);
end

dv(3)=y(4);

% disp([t,y'])