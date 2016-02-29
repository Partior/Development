%% Read Data

fmat={'SHAFT_POWER_COEFFICIENT';...
    'THRUST_COEFFICIENT';...
    'PROPELLER_EFFICIENCY_COMPARISON'};
f2={'C_P';'C_T';'n_P'};

clear dmat
dmat=struct;

% iterativly import data
for itr=1:length(fmat);
    flnm=['GNUPLOT_',fmat{itr},'.dat'];
    dd=importdata(flnm);
    d_in=find(dd(:,1)==0);
    eval(['dmat.',f2{itr},'=dd(d_in(3):d_in(4),:);']);
end

%% Develop Interpolants

for itr=1:length(f2); 
    assignin('base',f2{itr},....
        griddedInterpolant(eval(['dmat.',f2{itr},'(1:end-1,1)']),...
        eval(['dmat.',f2{itr},'(1:end-1,2)']),'pchip','none'));
end