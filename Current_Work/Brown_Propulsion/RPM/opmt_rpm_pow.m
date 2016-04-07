function [or]=opmt_rpm_pow(V,h,pck,nn,pow_ava)
% Optimized for power conservation

% package
min_rpm=750;
max_rpm=2500;

if nn==1
    or=fsolve(@(r) pck{nn}(V,h,r)/550-pow_ava,1500,optimset('display','off'));
else
    or=fsolve(@(r) pck{nn}(V,h,r,1.55)/550-pow_ava,1500,optimset('display','off'));
end

or(1)=min(max_rpm,or(1));
or(1)=max(min_rpm,or(1));