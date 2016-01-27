%% RANGE COMPARATOR

clear; clc
figure(1); clf
run('../cntsmaker.m')

constant_alpha % usesDR2
% constant_thrust% usesDR
constant_vel% usesDR3
constant_power% usesDR4


subplot(2,2,1); view(2); colorbar; title('Range')
subplot(2,2,2); view(3); grid on
subplot(2,2,3); view(3); grid on
subplot(2,2,4); view(3); grid on
