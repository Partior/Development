<<<<<<< HEAD
function [wwto,wwf]=west2(wr,wv,wld,we)

load('constants.mat');

%% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-wr*SFC/(wv/1.46666667*(0.943*wld)));
We=exp(-we*SFC/(wld));

% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
wwf=1.06*(1-W1_6);

%% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;

%% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
=======
function [wwto,wwf]=west2(wr,wv,wld,we)

load('constants.mat');

%% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-wr*SFC/(wv/1.46666667*(0.943*wld)));
We=exp(-we*SFC/(wld));

% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
wwf=1.06*(1-W1_6);

%% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;

%% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
wwto=fsolve(@(wt) wt*(1-wwf)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));    % Estimate W_TO