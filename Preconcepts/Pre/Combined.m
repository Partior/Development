Rdom=linspace(800,1500,20);
spdom=linspace(250,300,20);
for it=1:length(Rdom)
    for it2=1:length(spdom)
        % Given
%         R=900;
        R=Rdom(it);
%         V=250;
        V=spdom(it2);
        % Assumptions
        sfc=[0.5; 0.4]; %[Cruise;Loiter];
        E=0.25; %i.e. 60 min loiter time
        LD=17;
        AR=10;
        Cd0=0.022;
        e=0.8;
        opts=optimoptions('fsolve','Display','off');
        %% Weight Approximation Approximation

        %% Fixed Weight
        Wfix=(1+2+19)*225; % Attendent, Crew, Passengers

        

        %% Range and Takeoff
        LDm=LD;
        % Clm=fsolve(@(x) 1/LDm-(Cd0+1/(pi*AR*e)*(x^2))/x,1.5,opts); % approximated from L/D max and Cd0
        Cl_to=1.5;
        p=1.2673e-3; %rho at 20,000 ft
%         TW=0.4;
        % Grab weight loading
        rng=@(x) 1.07/sfc(1)*(x/(p)).^0.5*(AR*e)^(1/4)/Cd0^(3/4).*(1./Wto);
        Sto=@(x,TW) 20.9*(x/(Cl_to*TW))+69.6*sqrt((x/(Cl_to*TW))*TW);
        % Solve
        wld=fsolve(@(x) rng(x)*Wf_Wto.*Wto-R,30,opts);
        % New addition
        Tw=fsolve(@(x) Sto(wld,x)-2000,0.2,opts);
%         s_T=Sto(wld);
%         s_L=79.4*(wld/Cl_to)+50/tand(3);
        T(it,it2)=Tw*Wto;
        WS(it,it2)=wld;
        Wt(it,it2)=Wto;
        Rd(it,it2)=R;
        sp(it,it2)=V;
    end
end