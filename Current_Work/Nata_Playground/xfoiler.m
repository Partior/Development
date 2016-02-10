%% Run new polars for xfoil

% Pick which airofil we are using
NACA_NAME=input('NACA airfoils digits (numbers only):  ');
txt=fileread('runner.txt');
f1=fopen('NATA_Playground\for_xfoil.txt','w');
fprintf(f1,'NACA %s \n%s',num2str(NACA_NAME),txt);
fclose(f1);
clc

% Change fo xfoil's main path
cd('C:\Users\granataa\Desktop\Classes\15 Fall\Design\xfoil')

[~,~]=dos('echo Running.... I promise....','-echo');
% Run xfoil with the given text file for exectuion
[~,~]=dos('xfoil < "%HOMEPATH%\Desktop\Classes\15 Fall\Design\MATLAB\Current_Work\Nata_Playground\for_xfoil.txt"');

% And we're done!
cd('C:\Users\granataa\Desktop\Classes\15 Fall\Design\MATLAB\Current_Work')