%% Constraint function for cruise_optimum

function [c,ceq]=cruise_cond(X,v,pl_limit)

vi=X(1);
hi=X(2);

c=[];

% Power Limit
ts=v{1}(vi,hi);
pl=v{2}(ts,vi,hi);

ceq(1)=pl-pl_limit;