%% Gross Weight Takeoff Estimation
% Used to provide Contraint producer with estimated gross takeoff weight,
% assumptions for simple cruise

% Mission for fuel wieght is simple cruise
%     0-1 Takeoff 0.97
%     1-2 Climb 0.985
%     2-3 Cruise (For Range)
%     3-4 Descent 1
%     4-5 Loiter (for Time)
%     5-6 Decent 1
%     6   Landing 0.985

% Fuel Weight Fraction
% Fuel ratios
Wr=exp(-R*sfc/(V_c*(0.943*LD)));
We=exp(-E*sfc/(LD));
% Full ratio
W1_6=0.97*0.985*Wr*1*We*0.985;
Wf_Wto=1.06*(1-W1_6);

% Empty Weight
% From Trend line data, We=XX Wto ^ YY, XX=0.911, YY=0.947
Wept=@(Wt) 0.911*Wt^0.947;

% Takeoff Weight Estimation
% Compare We_est to Wto_est - Wfix - Wfuel
Wto=fsolve(@(wt) wt*(1-Wf_Wto)-Wfix-Wept(wt),30e3,optimoptions('fsolve','Display','off'));