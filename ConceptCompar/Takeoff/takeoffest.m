function takeoffest

W=16500;
SFC=0.45/3600;
mu=0.04;
Cdg=0.05;
Clg=1.6;
S=425;
p=2.3e-3;

a=1125.33;
vdom=linspace(0,a*0.5,300);

Vstall=sqrt(2*W/(S*2.3e-3*(Clg+0.1)));

n=6; %number of engines
Pa=860*550;
T=proppower(n,Pa);

%% Ground Run
    function dval=groundrun(t,val)
        dval=zeros(size(val));
        if val(2)>Vstall*1.15   %reached takeoff speed
            return
        end
        W=val(1);
        V=val(2);
        Ss=val(3);
        Tt=T(V)*nm;
        dval(1)=-Tt*SFC; % dW
        dval(2)=32.2*(Tt/W-mu)-32.2/W*1/2*p*S*V^2*(Cdg-mu*Clg);
        dval(3)=V;
    end

opts=odeset('RelTol',1e-5);
nm=1; % Running with full power
[t,r]=ode45(@groundrun,[0 360],[W,0.1,0],opts);

t=t(diff(r(:,1))~=0);
r=r(diff(r(:,1))~=0,:);

Wt=r(:,1);
Vt=r(:,2);
St=r(:,3);

%% Stopping Distance
% as Lift determines normal forces
muTire=0.72;
    function dval=sbrake(t,val)
        dval=zeros(size(val));
        Vs=val(1);
        Ss=val(2);
        Ws=val(3);
        if Vs<=0
            return
        end
        dval(2)=Vs;
        dval(3)=0;
        L=0.5*2.3e-3*Vs^2*S*Clg;
        abrake=32.2*muTire*(1-L/Ws);
        dval(1)=-abrake;
    end

Vlof_basic=sqrt(W/(0.5*2.3e-3*S*Clg));
vsdom=Vt(Vt<Vlof_basic);
for itr=1:length(vsdom)
    [tSss,Sss]=ode45(@sbrake,[0 150],[vsdom(itr),0,Wt(itr)],opts);
    Sst=Sss(Sss(:,1)~=0,:);
    tSst=tSss(Sss(:,1)~=0);
    S_b(itr,1)=Sst(end,2);
    t_b(itr,1)=tSst(end);
end

[~,ind]=min(abs(3000-St(1:length(vsdom))-S_b));
[~,Sbr_disp]=ode45(@sbrake,[0 150],[vsdom(ind),St(ind),Wt(ind)],opts);
    
%% One Engine Inoperable
% Worst Case Scenario, engine out at S_br
nm=(n-1)/n; % running OEI
[t_oei,r_oei]=ode45(@groundrun,[0 100],[Wt(ind),Vt(ind),St(ind)],opts);
t_oei=t_oei(diff(r_oei(:,1))~=0)+t(ind);
r_oei=r_oei(diff(r_oei(:,1))~=0,:);

Wt_oei=r_oei(:,1);
Vt_oei=r_oei(:,2);
St_oei=r_oei(:,3);

%% Airborne Distance
V2=max(172,Vstall*1.2); % ft/s, Vmp for climbing
Vlof=1.1*Vstall;
Sa=Wt(end)/(Pa/V2-0.5*p*V2^2*S*Cdg)*((V2^2-Vlof^2)/(2*32.2)+35);
Sa_oei=Wt_oei(end)/(nm*Pa/V2-0.5*p*V2^2*S*Cdg)*((V2^2-Vlof^2)/(2*32.2)+35);

%% Graphs

figure(1); clf
subplot(2,2,1:2)
plot(St,Vt/1.4666); xlabel('Dist, ft'); ylabel('Vel, mph')
hold on
plot(Sbr_disp(:,2),Sbr_disp(:,1)/1.4666,'r')
plot(St_oei,Vt_oei/1.4666,'g')
plot(St(end)+Sa,V2/1.4666,'b*')
plot(St_oei(end)+Sa_oei,V2/1.4666,'g*')
legend({'Takeoff','Emerg Brake','OEI'},'Location','south')
grid on

subplot(2,2,3)
plot(St,t); xlabel('Dist, ft'); ylabel('time, s')
hold on
plot(St_oei,t_oei,'g')
plot(St(end)+Sa,t(end)+Sa/V2,'b*')
plot(St_oei(end)+Sa_oei,t_oei(end)+Sa_oei/V2,'g*')
plot(St(ind),t(ind),'r*')
grid on

subplot(2,2,4)
plot(S_b,vsdom/1.4666,'r')
hold on
plot(St,Vt/1.4666,'b')
xlabel('Dist, ft'); ylabel('Vel, mph')
grid on




end