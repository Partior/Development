function s_a=sur(e_n,Rmax)
% output surface area taken up by certain prop (indicated by input
% engine_number)

prop_const
tap_ang=(r_chrd-t_chrd)/(b/2); %root chrd- tip chrd/ half of span don't bother taking 

x1=1*e_n;
for itr=2:e_n
    x1=x1+Rmax(min(itr-1,2))*2;
end

x2=x1+Rmax(min(e_n,2))*2;

y=6-[x1;x2]*tap_ang;
s_a=sum(y)/2*Rmax(min(e_n,2))*2;