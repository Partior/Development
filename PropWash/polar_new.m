%% New Drag Polar for the entire Aircraft
% Uses dynamic pressure ratios, % of props on, travel height and velocity
% to provie a drag polar for the entire aircraft
% 
% Combines the drag polar for the aircraft fuesalge (with assumeptions for
% appendeges) and adds the polar for the arifoil, assumeing higher flow
% velocity

%% Init
% run scripts to initalize variables
q_ratio     % sets up velocity ratios
airfoil_polar   % sets up fuselage drag
cd_new      % sets up airfoil drag polar

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone