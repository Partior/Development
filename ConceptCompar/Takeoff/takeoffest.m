function takeoffest

W=16500;
SFC=0.55/3600;
mu=0.04;
Cdg=0.05;
Clg=1.7;
S=425;

a=1125.33;
vdom=linspace(0,a*0.5,50);
Pa=1280*550;
T_i=Pa./vdom;
A=2^2*pi; p=2.3e-3;
T0=Pa^(2/3)*(2*p*A)^(1/3);
yt=spline(vdom([5,6,20,21]),[T0 T0 T_i([20,21])],vdom(6:20));
T_r=[T0*ones(1,5),yt,T_i(21:end)];
pT=interp1(vdom,T_r,'linear','pp');
T=@(V) ppval(pT,V);


%% Ground Run
    function dval=groundrun(t,val)
        dval=zeros(size(val));
        if val(2)>143*1.2   %reached takeoff speed
            return
        end
        W=val(1);
        V=val(2);
        Ss=val(3);
        Tt=T(V);
        dval(1)=-Tt*SFC; % dW
        dval(2)=32.2*(Tt/W-mu)-32.2/W*1/2*p*S*V^2*(Cdg-mu*Clg);
        dval(3)=V;
    end

opts=odeset('RelTol',1e-5);
[t,r]=ode45(@groundrun,[0 360],[W,0.1,0],opts);

t=t(diff(r(:,2))~=0);
Wt=r(diff(r(:,2))~=0,1);
Vt=r(diff(r(:,2))~=0,2);
St=r(diff(r(:,2))~=0,3);

%% Stopping Distance
muTire=0.72;
Ft=Wt*muTire;
at=Ft./(Wt/32.2);
Sst=Vt.^2./(2*at);
[~,ind]=min(abs(3000-St-Sst));

%% Airborne Distance
V2=172; % ft/s, Vmp for climbing
Sa=Wt(end)/(Pa/V2-0.5*p*V2^2*S*Cdg)*(50);


%% Graphs

clf
subplot(2,2,1)
plot(St,Vt/1.4666); xlabel('Dist, ft'); ylabel('Vel, mph')
hold on; plot(St(end)+Sa,V2/1.4666,'b*')
plot(St(ind),Vt(ind)/1.4666,'r*')
grid on

subplot(2,2,2)
plot(St,t); xlabel('Dist, ft'); ylabel('time, s')
hold on; plot(St(end)+Sa,t(end)+Sa/V2,'b*')
plot(St(ind),t(ind),'r*')
grid on

subplot(2,2,3)
plot(Vt/1.4666,Sst); xlabel('Vel, mph'); ylabel('Stop Dist, ft')
hold on; plot(Vt(ind)/1.4666,Sst(ind),'r*');
grid on





end