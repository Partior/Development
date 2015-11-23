%% LD Trade Study
% Looking at the attributes of LD at cruise speed

%% Initial Assumptions and Requirments of flight
load('../conceptCompar/constants.mat')

% Payload
%     19 Passengers w/ Cargo @ 225 lbs each, plus crew and attendent
Wfix=(19+2+1)*225;  % lbm
% Initial Performance Constants
sfc=0.5;    % specifc fuel consumption, lb_fuel per hour / lb_thrust
E=0.5;     % i.e. 30 min loiter time
AR=10;      % Aspect Ratio
Cd0=0.022;  % 
e=0.75;      % Oswald Efficency
% Cruise Enviromental Conditions
p_c=p(22e3);  % slugs per ft^3
% Takeoff Distance
s_T=3000;   % ft
% WS Restraint Constants
Cl_max=1.7;  % Max C_L for takeoff
% Convience Conditions
K=1/(e*pi*AR);
V_md=@(ws,p) sqrt(2*ws/(p*sqrt(Cd0/K)));
V_mp=@(ws,p) sqrt(2*ws/p)*(K/(3*Cd0))^(1/4);
p_sl=p(0); %slugs/ft^3, sea level density
% Service Ceiling
p_sc=p(28e3);   % slugs per ft^3

%% Domains of independent variables
Rl=26;  Rd=linspace(600,1000,Rl);  %miles
V_c=250*1.46666667;
LDl=21;  LDd=linspace(18,27,LDl);  % Keep resolution of LD <5

%% Numerical Calculations

% For loops to calculate WS, TW and P for independent Variables
optimzd=zeros(Rl,LDl,3);
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local')
end

for it_LD=1:LDl
    LD=LDd(it_LD);
    parfor it_R=1:Rl
        R=Rd(it_R);
            
            % Fuel Weight Fraction
            % Fuel ratios
            Wr=exp(-R*sfc/(V_c/1.46666667*(0.943*LD)));
            We=exp(-E*sfc/(LD));
            % Full ratio
            W1_6=0.97*0.985*Wr*1*We*0.985;
            Wf_Wto=1.06*(1-W1_6);
            % Empty Weight
            % From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
            Wept=@(Wt) 0.911*Wt^0.947;
            % Takeoff Weight Estimation
            % Compare We_est to Wto_est - Wfix - Wfuel
            Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));    % Estimate W_TO

            % Min loading for to meet Range requirement
            WS_r=fsolve(@(x) Wf_Wto*Wto*1.07/sfc*(x/(p_c))^0.5*(AR*e)^(1/4)/Cd0^(3/4)*(1/Wto)-R,10,optimoptions('fsolve','Display','off'));
            % Limit on W/S for Landing Distance within required distance, 3 degree
            % angle of approach
            WS_l=fsolve(@(ws) s_T-(79.4*ws/(1*Cl_max)+50/tand(3)),...
                50,optimoptions('fsolve','display','off'));
            
            % Drag for Power
            D=@(ws,V,p,dhdt,n) (Wto*dhdt)/V + (Cd0*V^2*Wto*p)/(2*ws) + (2*K*Wto*n^2*ws)/(V^2*p);

            % Calculations for Power
            % Straight, Level Flight
            Preq_cruise=@(ws) D(ws,V_c,p_c,0,1)*V_c/sqrt((p_c/p_sl));
            % Service Ceiling
            Preq_serv=@(ws) D(ws,V_mp(ws,p_sc),p_sc,100/60,1).*V_mp(ws,p_sc)/sqrt((p_sc/p_sl));
            
            mat=[{Preq_cruise};{Preq_serv}];
            [wsx,py]=fminbnd(@(ws) max([mat{1}(ws),mat{2}(ws)]),WS_r,WS_l);
            if numel(wsx>1)
                wsx=wsx(1);
            end
            optm=[wsx,py/550];    % in lbs/ft^2 and hp
%             optm=[WS_l,Preq_cruise(WS_l)/550];    % in lbs/ft^2 and hp
            
            optimzd(it_R,it_LD,:)=[optm,Wto]; % Save Optimized Data
    end
end

%% plotting- Range constant for power required
[ld_msh,r_msh]=meshgrid(LDd,Rd);
figure(1); clf; hold on

[~,hs]=contour(r_msh,ld_msh,optimzd(:,:,1),1);
set(hs,...
    'LineColor','r','LineWidth',1,'LineStyle','-',...
    'ShowText','on','LabelSpacing',400);
[~,hP]=contour(r_msh,ld_msh,optimzd(:,:,2)/1e2);
set(hP,...
    'LineColor','k','LineWidth',1,'LineStyle','-',...
    'ShowText','on','LabelSpacing',400);
[~,hw]=contour(r_msh,ld_msh,optimzd(:,:,3)/1e3);
set(hw,...
    'LineColor','b','LineWidth',1,'LineStyle','-',...
    'ShowText','on','LabelSpacing',400);

%% Pretty
title('Power Required, \color{red}Wing Loading, \color{blue}Weight')
xlabel('Range, miles')
ylabel('L/D')