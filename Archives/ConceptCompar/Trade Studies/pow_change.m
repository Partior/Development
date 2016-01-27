%% Power Change

% called by trd_stud

parfor itb=1:100
    p0(itb)=plvl(250*1.466,hdom(itb),TOGW,Pa);
end
preq=mean(p0);

%% Prop Efficiency Changes
wb=waitbar(0,'Prop Effc');
for ita=1:40
    waitbar(ita/40,wb)
    npi=np_dom(ita);
    preq_np(ita)=np/npi;
end

%% Number of Props
waitbar(0,wb,'Num Prop')
for ita=1:4
    waitbar(ita/4,wb)
    nprops=num_dom(ita);
    T=proppower(nprops,Pa,false);
    parfor itb=1:100
        pr(itb)=plvl(250*1.466,hdom(itb),TOGW,T(250*1.466)*250*1.466);
    end
    preq_nump(ita)=mean(pr)/preq;
end

%% Gross Weight
waitbar(0,wb,'TOGW')
for ita=1:40
    waitbar(ita/40,wb)
    TOGWi=TOGW*TOGW_dom(ita);
    parfor itb=1:100
        p2(itb)=plvl(250*1.466,hdom(itb),TOGWi,Pa);
    end
    preq_TOGW(ita)=mean(p2)/preq;
end

%%
close(wb)
