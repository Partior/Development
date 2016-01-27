%% Fuel Efficiecy

% called by trd_stud


Temp=@(h) 15.0-6.5*(h/3280.84)+273.15;  % input h of feet, output of Temp in kel
a=@(h) sqrt(1.4*287.058*Temp(h))*3.28084;   % mach 1 in feet per second
beta=@(m) sqrt(1-m.^2);
cd=@(v,h) Cd0./beta(v./a(h));

gmma=@(v,h,W) v./(SFC/3600*(cd(v,h)*S.*v.^2.*p(h)*1/2+2*K*W^2./(S*v.^2.*p(h))));
plvl=@(v,h,W,bhp) (0.5*v.^3.*p(h)*S.*cd(v,h)+K*W^2./(0.5*v.*p(h)*S))./(bhp*sqrt(p(h)/p(0)));

hdom=linspace(18e3,30e3,100);
vmax=zeros(1,100); gm=zeros(1,100);

%% Parallel
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool('local')
end

parfor itb=1:100
    vmax(itb)=fsolve(@(v) 1-plvl(v,hdom(itb),TOGW,Pa),300,...
        optimoptions('fsolve','Display','off'));
    gm(itb)=gmma(vmax(itb),hdom(itb),TOGW);
end
[~,in]=max(gm);
gm_n0=gm(in);

%% Prop Efficiency Changes
wb=waitbar(0,'Prop Effc');
for ita=1:40
    waitbar(ita/40,wb)
    npi=np_dom(ita);
    BHP=Pa*npi/np;
    parfor itb=1:100
        vmax(itb)=fsolve(@(v) 1-plvl(v,hdom(itb),TOGW,BHP),300,...
            optimoptions('fsolve','Display','off'));
        gm(itb)=gmma(vmax(itb),hdom(itb),TOGW);
    end
    [~,in]=max(gm);
    gm_np(ita)=gm(in);
end

%% Number of Props
waitbar(0,wb,'Num Prop')
for ita=1:4
    waitbar(ita/4,wb)
    nprops=num_dom(ita);
    T=proppower(nprops,Pa,false);
    parfor itb=1:100
        vmax(itb)=fsolve(@(v) 1-plvl(v,hdom(itb),TOGW,T(v)*v),300,...
            optimoptions('fsolve','Display','off'));
        gm(itb)=gmma(vmax(itb),hdom(itb),TOGW);
    end
    [~,in]=max(gm);
    gm_nump(ita)=gm(in);
end

%% Gross Weight
waitbar(0,wb,'TOGW')
for ita=1:40
    waitbar(ita/40,wb)
    TOGWi=TOGW*TOGW_dom(ita);
    parfor itb=1:100
        vmax(itb)=fsolve(@(v) 1-plvl(v,hdom(itb),TOGWi,Pa),300,...
            optimoptions('fsolve','Display','off'));
        gm(itb)=gmma(vmax(itb),hdom(itb),TOGWi);
    end
    [~,in]=max(gm);
    gm_TOGW(ita)=gm(in);
end

close(wb)