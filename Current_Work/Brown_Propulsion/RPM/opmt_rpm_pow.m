function [or]=opmt_rpm_pow(V,h,pck,nn)
% Optimized for power conservation

% package
Rmax=pck{3};
Cr_P=pck{6};
Tk_P=pck{7};
n_Pc=pck{8};
n_Pt=pck{9};


min_rpm=750;
max_rpm=2500;

rpm_dom=min_rpm:0.5:max_rpm;

if nn==1
    % cruise
    %     or=fsolve(@(rr) Cr_P(V,0,rr)/550-340,1000,optsopts);
    in1=find(abs(Cr_P(V,h,rpm_dom)/550-340)<2);
    [~,in2]=max(n_Pc(j_ratio(V,rpm_dom(in1),Rmax(1))));
    or=rpm_dom(in1(in2));
    if isempty(or)
        or=max_rpm;
    end
else
    % tkaeoff
    %     or=fsolve(@(rr) Cr_P(V,0,rr)/550-340,1000,optsopts);
    in1=find(abs(Tk_P(V,h,rpm_dom)/550-63.333)<2);
    [~,in2]=max(n_Pt(j_ratio(V,...
        rpm_dom(in1),...
        Rmax(2))));
    or=rpm_dom(in1(in2));
    if isempty(or)
        or=max_rpm;
    end
end

