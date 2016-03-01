%% Read Data

fmat={'SHAFT_POWER_COEFFICIENT';...
    'THRUST_COEFFICIENT';...
    'PROPELLER_EFFICIENCY_COMPARISON'};
f2={'C_P';'C_T';'n_P'};

clear dmat
dmat=struct;

% iterativly import data
for itr=1:length(fmat);
    flnm=['Prop_output/Cruise/GNUPLOT_',fmat{itr},'.dat'];
    dd=importdata(flnm);
    d_in=find(dd(:,1)==0);
    eval(['dmat.',f2{itr},'=dd(d_in(4):d_in(5),:);']);
end

mstep1=mean(diff(dmat.C_P(1:10,1)));

for itr=1:length(fmat);
    flnm=['Prop_output/Takeoff/GNUPLOT_',fmat{itr},'.dat'];
    dd=importdata(flnm);
    d_in=find(dd(:,1)==0);
    eval(['emat.',f2{itr},'=dd(d_in(4):end,:);']);
end
mstep2=mean(diff(emat.C_P(1:10,1)));

%% Develop Interpolants

for itr=1:length(f2); 
    assignin('base',[f2{itr},'c'],....
        griddedInterpolant([eval(['dmat.',f2{itr},'(1:end-1,1)']);eval(['dmat.',f2{itr},'(end-1,1)+mstep1'])],...
        [eval(['dmat.',f2{itr},'(1:end-1,2)']);0],'pchip','nearest'));
end
for itr=1:length(f2); 
    assignin('base',[f2{itr},'t'],....
        griddedInterpolant([eval(['emat.',f2{itr},'(1:end-1,1)']);eval(['emat.',f2{itr},'(end-1,1)+mstep2'])],...
        [eval(['emat.',f2{itr},'(1:end-1,2)']);0],'pchip','nearest'));
end