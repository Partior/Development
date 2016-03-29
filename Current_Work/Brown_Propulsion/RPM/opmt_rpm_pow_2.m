function [or]=opmt_rpm_pow_2(V,h,pck,varargin)
% Optimized for power conservation

% package
min_rpm=750;
max_rpm=2500;

curves_P={pck{3};pck{4}};
nn=varargin{1};
pow_ava=varargin{2};
resol=20;
x1=linspace(min_rpm,max_rpm,resol)';
y1=zeros(resol,1); y2=zeros(resol,1);
for ia=1:resol
    y1(ia)=fzero(@(p) curves_P{nn}(V,h,x1(ia),p)/550-pow_ava,2,optimset('display','off','TolX',1e-4));
    if isnan(y1(ia))
        y2(ia)=NaN;
    else
        y2(ia)=curves_P{nn}(V,h,x1(ia),y1(ia))/550;
    end
end
% find center and re-evaluate
x1=linspace(min(x1(~isnan(y2))),max(x1(~isnan(y2))),resol);
for ia=1:resol
    y1(ia)=fzero(@(p) curves_P{nn}(V,h,x1(ia),p)/550-pow_ava,2,optimset('display','off','TolX',1e-4));
    if isnan(y1(ia))
        y2(ia)=NaN;
    else
        y2(ia)=curves_P{nn}(V,h,x1(ia),y1(ia))/550;
    end
end
x2=x1(~isnan(y2));
y1_2=y1(~isnan(y2));
y2_2=y2(~isnan(y2));
% keyboard
cont=true;
nmn=1;
if length(y2_2)<3
    or(1)=x2;
    or(2)=y1_2;
else
    while cont
        if abs(y2_2(end-nmn)-pow_ava)<5e-2 || nmn+2>length(y2_2)
            or(1)=x2(end-nmn);
            or(2)=y1_2(end-nmn);
            cont=false;
        else
            nmn=nmn+1;
        end
    end
end

or(1)=min(max_rpm,or(1));
or(1)=max(min_rpm,or(1));