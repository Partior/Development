function [value,isterminal,direction]=events_empty_fuel_pr(~,y,~,~)
prop_const
value=double(y(1)>0);
isterminal=1;
direction=0;