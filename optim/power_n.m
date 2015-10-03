%% Power to Constraints _ Numerical
% Modification of constr.m for the purposes of numeric output only.

%% Calculations for Power
% Straight, Level Flight
Preq_cruise=D(WSdom,V_c,p_c)*V_c/(p_c/p_sl);
% Service Ceiling
Preq_serv=(D(WSdom,V_md(WSdom,p_sc),p_sc).*V_md(WSdom,p_sc)/(p_sc/p_sl))+...
    Wto*(100/60);
% Cruise Ceiling
Preq_cc=D(WSdom,V_md(WSdom,p_c),p_sc).*V_md(WSdom,p_c)/(p_c/p_sl)+...
    Wto*(300/60);
% 2.5g Maneuer at Sea Level
Preq_man=D(WSdom,V_c,p_sl)*V_c/(p_sl/p_sl);