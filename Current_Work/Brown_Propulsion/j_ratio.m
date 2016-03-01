function J=j_ratio(V,n,r)
%% Advance Ratio Calculator
% J=j_ratio(V)
% inputs: V, n, D
%   V: velocity in ft/sec
%   n: revolutions per minute of motor
%   r: radius of the propeller blades

rps=n/60;   %rpm to rps
D=r*2;  %radius to diamater

J=V./(rps*D);
