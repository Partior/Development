%% Altitude Effects;
%  This script describes the effects of alittude on power output of the
%  turbo-electirc generators:


% Using turbo charger function, from line C of graph on 
% http://rwebs.net/avhistory/opsman/geturbo/geturbo.htm
alt_effect=@(h) min([0.90;1.132*p(h)/p(10e3)-0.132]);