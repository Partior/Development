function [value,isterminal,direction]=events_grnd_wash(~,y,~,~)

value=double(y(2)<90*1.4666);
isterminal=1;
direction=0;