function [value,isterminal,direction]=events_empty_fuel(~,y,~)
value=double(y(1)>0);
isterminal=1;
direction=0;