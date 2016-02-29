%% Data Analysis and Display
% Use output files (.dat files) from the maps folders to develop
% information for a particular setting of the propeller

% Which data do we want?
fmat={'SHAFT_POWER_COMPARISON_SHP';...
    'SHAFT_POWER_COEFFICIENT';...
    'THRUST_COEFFICIENT';...
    'THRUST_COMPARISON_LBF';...
    'PROPELLER_EFFICIENCY_COMPARISON'};

clear dmat
dmat=struct;

% iterativly import data
for itr=1:length(fmat);
    flnm=['C:\Users\granata\Desktop\PropDesign\',...
        'PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT\GNUPLOT_',...
        fmat{itr},'.DAT'];
    dd=importdata(flnm);
    d_in=find(dd(:,1)==0);
    eval(['dmat.',fmat{itr},'=dd(d_in(3):d_in(4),:);']);
end


