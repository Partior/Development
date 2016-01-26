%% Comparision of Developed Cl/Cd to norm


%% Init
% run scripts to initalize variables
clear;
prop_const

%% Init Scripts
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

%%
figure(1); clf; hold on
fact_q=1/(0.5*p(25e3)*366^2*S);
%% Parabolic
adom=linspace(-12,15-incd,60);

Cl_p=Cla(adom);
Cd_p=0.022+K*(Cl_p).^2;
plot(Cl_p,Cd_p)
xlabel('C_L')
ylabel('C_D')
% %% 8 Engine
% Cl_w8=L(adom,25e3,366,n);
% for itr=1:60;
% Cd_w8(itr)=D(adom(itr),25e3,366,n);
% end
% plot(Cl_w8*fact_q,Cd_w8*fact_q)

%% NACA 23015
plot(Cl_p,Cda(adom),'-.')


%% Two Engine
n=12;
prop_T
v2=@(v,t,h) sqrt(t/(1/2*p(h)*A)+v^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

Cl_w2=[Lw(adom,25e3,366,n);Lf(adom,25e3,366)];
for itr=1:60;
Cd_w2(:,itr)=[Dw(adom(itr),25e3,366,n);Df(adom(itr),25e3,366)];
end
plot(Cl_w2(1,:)*fact_q,Cd_w2(1,:)*fact_q,'--')
plot(Cl_w2(2,:)*fact_q,Cd_w2(2,:)*fact_q,'--')

plot(sum(Cl_w2,1)*fact_q,sum(Cd_w2,1)*fact_q)

legend({'Parabolic','NACA 23015','Wing','Fuselage','Total Aircraft'})

%%
figure(2); clf; hold on
[ha,h1,h2]=plotyy(adom,Cl_w2'*fact_q,adom,Cd_w2'*fact_q);
h1(1).LineStyle='--';
h1(2).LineStyle='--';
ha(1).YLabel.String='C_L';
ha(1).XLabel.String='AoA';
ha(2).YLabel.String='C_D';
ha(1).YLim=[-2 2];

%% 
figure(3); hold on
plot(adom,sum(Cl_w2,1)./sum(Cd_w2,1))
