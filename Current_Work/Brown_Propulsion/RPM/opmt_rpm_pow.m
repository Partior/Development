function [or]=opmt_rpm_pow(V,h,pck,varargin)
% Optimized for power conservation

% package
min_rpm=750;
max_rpm=2500;

curves_P={pck{3};pck{4}};
nn=varargin{1};
if nargin<=5
    pow_ava=varargin{2};
    if nn==1
        or=fzero(@(r) curves_P{nn}(V,h,r)/550-pow_ava,2000);
    else
        or=fzero(@(r) curves_P{nn}(V,h,r,1.55)/550-pow_ava,2000);
    end
else
    pow_ava=varargin{2};
    %         keyboard
    T_target=varargin{3};
    [x,~,flg,~]=fmincon(@func,[2400;2.9],[],[],[],[],...
        [min_rpm;1.5],[max_rpm;3],@cons,...
        optimset('display','off','TolCon',1e-12,'TolFun',1e-12,'TypicalX',[1800;1.575],'TolX',1e-20));
    or=[x;flg];
end
    function f=func(x)
        if isempty(T_target)
            f=-pck{2}(V,h,x(1),x(2));
        else
            f=pck{4}(V,h,x(1),x(2));
        end
    end
    function [c,ceq]=cons(x)
        c(1)=pck{4}(V,h,x(1),x(2))/550-pow_ava;
        if ~isempty(T_target)
            c(2)=T_target-pck{2}(V,h,x(1),x(2));
        end
        ceq=[];
    end


or(1)=min(max_rpm,or(1));
or(1)=max(min_rpm,or(1));
end