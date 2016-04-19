%% Payload - Range Diagram

% Develop a Payload/Range Diagram

%% Init Scripts
prop_const
prop_T
v2=@(v,t,h,pt) sqrt(t/(1/2*p(h)*A(pt))+v.^2);   % velocity ratio, velocity, thrust, h

airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

equations_wash  % sets up lift and drag functions

v=250*1.4666;
h=25e3;
ne=2;
save('FINAL/PR_diagram/pr_const.mat','v','h','ne','L','D','SFC_eq','W0','Wf','Cr_P','Cr_T')

%% Ode Script
% thrid Regieme: max fuel, iterating through payloads
resol=5;
WEG=[linspace(0,Wfix(19),resol),linspace(Wfix(19),Wfix(19)+600,resol)];
RNG=zeros(size(WEG));

powdom=0.7:0.1:1;
gmma=@(v,P) v/SFC_eq(P)/5280;
xsol=zeros(2,length(powdom));
gmsol=zeros(1,length(powdom));
wb=waitbar(0,'Iterating through Payloads');
for itr=1:resol*2
    waitbar(itr/(resol*2),wb)
    ts=@(vi,hi) fzero(@(rr) L(rr,hi,vi,2)-(W0(19)+WEG(itr)-Wfix(19)),[Cl0-incd Clmax-incd],optimoptions('fsolve','display','off','TolX',1e-2));
    ps=@(tt,vi,hi) D(tt,hi,vi,2)/(2*Cr_T(vi,hi,opmt_rpm_pow(vi,hi,{Cr_P;Tk_P},1,340)));
    v={ts,ps,gmma};
    parfor ita=1:length(powdom)
        pl_limit=powdom(ita);
        [xsol(:,ita),gmsol(ita)]=fmincon(@(X) cruise_objec(X,v),...
            [350;24e3],[],[],[],[],[250*1.4666;18e3],[450;31e3],@(X) cruise_cond(X,v,pl_limit),optimset('Display','off','TolFun',1e-3));
    end
    clear functions
    [~,in]=max(gmsol);
    [t,~]=ode45(@iterr_pr,[0 5e4],Wf,...
        odeset('Events',@events_empty_fuel_pr,'RelTol',1e-2),...
        WEG(itr)-Wfix(19),xsol(:,in));
    RNG(itr)=t(end)*xsol(1,in)*1.4666/5280/1.151;
end

%% Plot Basic Curve
if ~exist('pyrng','var')
    pyrng=figure();
    pyrax=gca;
end
plot(pyrax,[RNG,0],[WEG,WEG(end)],'-b')
hold on
plot(pyrax,[RNG,0],[WEG,WEG(end)]+[Wf*ones(1,resol),Wf-linspace(0,600,resol),0],'-r')
