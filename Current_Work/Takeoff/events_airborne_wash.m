function [value,isterminal,direction]=events_airborne_wash(~,val,~,ne,~)

h=val(5);

value=double(50<h);
isterminal=1;
direction=0;