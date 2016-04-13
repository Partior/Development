%% Descent


vert_v=2500/60; % fps vertical velocity

W_Descent=W0(19)-0.9*Wf;
h=10e3;
fvdom=linspace(200,400,10);

parfor it=1:10
    forw_v=fvdom(it);
    gm(it)=atand(vert_v/forw_v);
    vel=norm([vert_v,forw_v]);
    v={gm(it),h,vel,L,D,W_Descent,package,Cr_T};
    X=fmincon(@(X) X(2),...
        [5;250],[],[],[],[],[-10;10],[Clmax-incd,340],@(X) cond_desc(X,v));
    
    a_des(it)=X(1);
    pow(it)=X(2);
    [c,~]=cond_desc(X,v);
    fy(it)=c(1);
    fx(it)=c(2);
    f_gm(it)=vel/SFC_eq(pow(it)*2)/5280;
end

