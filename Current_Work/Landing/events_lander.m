function [value,isterminal,direction]=events_lander(~,val)

% for AoA=0
value(1)=val(1);
isterminal(1)=0;
direction(1)=0;

% for Velocity=0
value(2)=val(4);
isterminal(2)=1;
direction(2)=0;
