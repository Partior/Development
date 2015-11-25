function [value,isterminal,direction]=events_sbrk_wash(~,y,~)

value=double(y(2)>1);
isterminal=1;
direction=0;