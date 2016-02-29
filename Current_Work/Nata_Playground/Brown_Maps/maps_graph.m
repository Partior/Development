%% Plotter for analysis output data

clear all; close all; clc
opt_in_modder
data_er

%% Folder and File Set UP
addpath('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT');
% Iterate for various amounts of data
newtt=fileread('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT\PROP_DESIGN_MAPS_INPUT_ONE.TXT');
fildID=fopen('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT\PROP_DESIGN_MAPS_INPUT_ONE.TXT','w');

%% Domain setup
altt=[0,1e4:5e3:3e4];
l=strfind(newtt,'ALTITUDE');
arra_a=(l-22:l-7);
% initilzed the storage varaible
data_in

fmat={'SHAFT_POWER_COEFFICIENT';...
    'THRUST_COEFFICIENT';...
    'PROPELLER_EFFICIENCY_COMPARISON'};

%% FOR LOOPS

wtw=waitbar(0);
cd('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT');

for itb=1:length(altt)
    waitbar(itb/length(altt),wtw)
    newtt(arra_a)=sprintf('%16.3f',altt(itb));
    fildID=fopen('C:\Users\granata\Desktop\PropDesign\PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT\PROP_DESIGN_MAPS_INPUT_ONE.TXT','w');
    fprintf(fildID,newtt);
    fclose(fildID);
    [~,~]=dos('r');
    parfor itr=1:length(fmat);
        flnm=['C:\Users\granata\Desktop\PropDesign\',...
            'PROP_DESIGN 64-bit Windows Versions\PROP_DESIGN\MAPS_ALT\GNUPLOT_',...
            fmat{itr},'.DAT'];
        dd=importdata(flnm);
        d_in=find(dd(:,1)==0);
        full_data{itb,itr}=dd(d_in(3):d_in(4),:);
    end
end

cd('C:\Users\granata\Desktop\MATLAB Files\Partior\Current_Work\Nata_Playground\Brown_Maps');
close(wtw)

%% Start Plotting

for itc=1:length(fmat)
    figure(itc); clf
    hold on
    for itb=1:length(altt)
        interr=cell2mat(full_data(itb,itc));
        plot(interr(1:end-1,1),interr(1:end-1,2),'-')
    end
    title(fmat{itc},'Interpreter','none')
    xlabel('Advance Ratio: J/nD')
    ylabel('Percentage, %')
end
