%% Find Optimum point for Required Power to Wing Loading

% Find Max of any given operation at any point:
[c,refin]=max([Preq_cc;Preq_cruise;Preq_man;Preq_serv]);
% Find the index of the minumum of 'c'
[c2,in]=min(c);
% Optimum is at WSdom(in),C2
optm=[WSdom(in),c2/550];    % in lbs/ft^2 and hp
% Which curve did it come from?
reff=refin(in);