function [value,isterminal,direction]=events_grnd_wash(~,val,~,ne)

load('takeoff_const.mat','VLOF')
Vt=val(2);

value=double(VLOF<Vt);
isterminal=1;
direction=0;