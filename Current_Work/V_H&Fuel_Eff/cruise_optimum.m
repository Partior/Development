%% Best Cruise Conditions

% Iterate through various power availabilities

powdom=linspace(0.75,1,20);

xsol=zeros(2,length(powdom));
gmsol=zeros(1,length(powdom));

ts=@(vi,hi) fzero(@(rr) L(rr,hi,vi,2)-W0(19),[Cl0-incd Clmax-incd],optimoptions('fsolve','display','off'));
ps=@(tt,vi,hi) D(tt,hi,vi,2)/(2*Cr_T(vi,hi,opmt_rpm_pow(vi,hi,{Cr_P;Tk_P},1,340)));
v={ts,ps,gmma};
itr=0;
parfor ita=1:length(powdom)
    pl_limit=powdom(ita);
    [xsol(:,ita),gmsol(ita)]=fmincon(@(X) cruise_objec(X,v),...
        [350;24e3],[],[],[],[],[250*1.4666;18e3],[450;31e3],@(X) cruise_cond(X,v,pl_limit),optimset('Display','off'));
end

%% Graph it
figure(5); clf
subplot(2,2,1)
plot(powdom,xsol(1,:)/1.4666)
xlabel('Power %')
ylabel('Velocity, mph')

subplot(2,2,2)
plot(powdom,xsol(1,:)./a(xsol(2,:)))
xlabel('Power %')
ylabel('Mach')

subplot(2,2,3)
plot(powdom,xsol(2,:)/1e3)
xlabel('Power %')
ylabel('Altitude 1,000 ft')

subplot(2,2,4)
plot(powdom,-gmsol)
xlabel('Power %')
ylabel('Fuel Econ, miles/pound')