function [value,isterminal,direction]=events_empty_fuel(~,y,~)
prop_const
value=double(y(1)>Wf*0);
isterminal=1;
direction=0;