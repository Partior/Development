%% PRETTY

% anyway, make a model that changes according to the adjusting parameters
% that one adds and changes around

%% INIT
addpath('../')
prop_const
% Init Scripts
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   
airfoil_polar
cd_new
equations_wash

%% Figure
if isempty(whos('modll'))
    modll=figure;
    modll.Name='Model Of Q==1';
    modll.MenuBar='none';
    if isempty(whos('modax'))
        modax=gca;
        modax.XLabel.String='X';
        modax.YLabel.String='Y';
    end
end

axes(modax)
cla
%% FUSELAGE

diam=9;
len=80;

% Nose and mirror tail
[xs,ys,zs]=sphere(60);
xn=diam/2*xs(:,all(xs>=0,1)); yn=diam/2*ys(:,all(xs>=0,1)); zn=diam/2*zs(:,all(xs>=0,1));
ZN=surface(100+diam-xn*2,yn,zn,'FaceColor','k','FaceAlpha',0.65,'EdgeColor','k');
ZT=surface(100+len-diam/2+xn,yn,zn,'FaceColor','k','FaceAlpha',0.65,'EdgeColor','k');

% Fuselage
Fuse_Stat=linspace(diam,len-diam/2,60);
xfus=ones(length([yn(:,end);flipud(yn(:,1))]),1)*Fuse_Stat;
yfus=[yn(:,end);flipud(yn(:,1))]*ones(1,length(Fuse_Stat));
zfus=[zn(:,end);flipud(zn(:,1))]*ones(1,length(Fuse_Stat));
ZF=surface(100+xfus,yfus,zfus,'FaceColor','k','FaceAlpha',0.65,'EdgeColor','k');

%% Empenage
SE=S*0.45;
ARE=6;
bE=sqrt(ARE*SE);
chrdE=SE/bE;
ydomE=linspace(0,bE,80);
r_pro=ones(size(ydomE));
r_pro(ydomE<2)=sin(ydomE(ydomE<2)/ydomE(find(ydomE<2,1,'last'))*pi/2);
r_pro(ydomE>bE-2)=fliplr(r_pro(ydomE<2));
[xe,ye,ze]=cylinder(r_pro,60);
EM=surface(100+len-diam/2+xe*chrdE,ze*bE-bE/2,ye*0.2+diam/2-0.2,'FaceColor','g','FaceAlpha',0.65,'EdgeColor','g');

%% Main Wing
cg=len*0.45;
c_wing=cg-chrd*0.35+chrd/2;
WING=surface(100+c_wing+xe*chrd/2,ze*b-b/2,ye*0.3,'FaceColor','b','FaceAlpha',0.65,'EdgeColor','b');

%% Propellers
yp=Rmax*cos(linspace(0,2*pi,60))'; zp=Rmax*sin(linspace(0,2*pi,60))';
xp=(100+c_wing-chrd/2-0.1)*ones(size(yp));

for itp=2:2:n
    centprop=diam/2+itp/2*(Rmax*2+0.1)-Rmax;
    Props(itp)=patch(xp,centprop+yp,zp,ones(size(zp)));
    Props(itp-1)=patch(xp,-centprop+yp,zp,ones(size(zp)));
end
for itp=1:n
    Props(itp).FaceColor='r';
end

