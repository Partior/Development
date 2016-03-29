%% Read Data

fmat={'SHAFT_POWER_COEFFICIENT';...
    'THRUST_COEFFICIENT';...
    'PROPELLER_EFFICIENCY_COMPARISON'};
f2={'C_P';'C_T';'n_P'};

% iterativly import cruise prop data
for itr=1:length(fmat);
    flnm=['Prop_output/Cruise/GNUPLOT_',fmat{itr},'.dat'];
    dd=importdata(flnm);
    d_in=find(dd(:,1)==0);
    eval(['dmat.',f2{itr},'=dd(d_in(4):d_in(5),:);']);
end
mstep1=mean(diff(dmat.C_P(1:10,1)));

%% Takeoff Prop Data
resol=13;
pitchdom=linspace(1.55,3.00,resol);
for curitr=1:resol
    for itr=1:length(fmat);
        fldr=['p_',num2str(round(pitchdom(curitr),2)*100),'/'];
        flnm=['Prop_output/Takeoff/',fldr,'GNUPLOT_',fmat{itr},'.dat'];
        dd=importdata(flnm);
        if itr==1
            emat{curitr}=dd(1:end,:);
        else
            emat{curitr}(:,itr+1)=dd(:,2);
        end
    end
end
mstep2=mean(diff(emat{1}(1:10,1)));
lgnth=length(emat{end});
for curitr=1:resol-1
    l1=length(emat{curitr});
    emat{curitr}=[emat{curitr};[mstep2*(l1:lgnth-1)',zeros(lgnth-l1,3)]];
end
for curitr=1:resol
    if curitr==1
        ematcomb=emat{curitr};
    else
        ematcomb(:,curitr*3-1:curitr*3+1)=emat{curitr}(:,2:4);
    end
end
%% Develop Interpolants

for itr=1:length(f2);
    assignin('base',[f2{itr},'c'],....
        griddedInterpolant([eval(['dmat.',f2{itr},'(1:end-1,1)']);eval(['dmat.',f2{itr},'(end-1,1)+mstep1'])],...
        [eval(['dmat.',f2{itr},'(1:end-1,2)']);0],'pchip','nearest'));
end
for itr=1:length(f2);
    assignin('base',[f2{itr},'t'],....
        griddedInterpolant({ematcomb(:,1),linspace(1.55,3.00,13)},ematcomb(:,1+itr+3*(0:resol-1)),'cubic','nearest'));
end