%% Objective Fucntion for Cruise_optimum

function f=cruise_objec(X,v)

vi=X(1);
hi=X(2);

ts=v{1}(vi,hi);
pl=v{2}(ts,vi,hi);
f=-v{3}(vi,pl*680);