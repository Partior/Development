%% Cruise Power

figure(1); clf
run('../cntsmaker.m')
subplot(2,1,1); hold on
subplot(2,1,2); hold on

Pa=850*550;

p=@(h) 2.3e-5*exp(3.2e-5*h);


for Wpay=225*[3,22];
    W0=We+Wf+Wpay;
    
%% Max Cruise
subplot(2,1,1)
fplot(@(h) (Pa/(0.5*p(h)*S
% Efficient