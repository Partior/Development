%% Determine best Cruise conditions above 250 mph

function [x,f]=optm_cruise()
% outputs true range
load('function_worker.mat','L','Cr_T','D','SFC_eq','W0','Wf','Cr_P','Cl0','Clmax','incd','Tc')
clear functions

    function f=ojec(X)
        [t,~]=ode45(@iterr2,[0 2.5e4],Wf,...
            odeset('Events',@events_empty_fuel,'RelTol',1e-6),...
            {L,Cr_T,D,SFC_eq,W0,Wf,Cr_P,X});
        f=t(end)*X(1)/5280;
    end

    function [c,ceq]=connn(X)
        ceq=[];
        hi=X(2);
        vi=X(1);
        c=D(fzero(@(rr) L(rr,hi,vi,2)-W0(19),[Cl0-incd Clmax-incd],optimoptions('fsolve','display','off')),hi,vi,2)-Tc(vi,hi);
    end

[x,f]=fmincon(@(X) -ojec(X),[375;20e3],[],[],[],[],[366;18e3],[],@connn,...
    optimoptions('fmincon','UseParallel',true,'display','final','TolX',1e-3,'TolFun',1e-3));

end
