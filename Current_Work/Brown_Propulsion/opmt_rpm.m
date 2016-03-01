function [or]=opmt_rpm(V,pck,nn)

% package
pk_jc=pck{1};
pk_jt=pck{2};
Rmax=pck{3};
Cr_T=pck{4};
Tk_T=pck{5};

min_rpm=1000;
opt_rpm=2000;
max_rpm=2500;

opts=optimset('Display','none','TolX',1e-9);
rpm_dom=min_rpm:0.5:opt_rpm;
% if nn==1
    % cruise
    if V<pk_jc*opt_rpm/60*2*Rmax(1)
        [~,in]=min(-Cr_T(V,0,rpm_dom));
        or=rpm_dom(in);
    else
        or=min(V/(Rmax(1)*2)/pk_jc*60,max_rpm);
    end
% else
%     % takeoff
%     if j_ratio(V,opt_rpm,Rmax(2))<pk_jt
%         or=fminbnd(@(rr) -Tk_T(V,0,rr),min_rpm,opt_rpm);
%     else
%         or=min(V/(Rmax(2)*2)/pk_jc*60,max_rpm);
%     end
% end
