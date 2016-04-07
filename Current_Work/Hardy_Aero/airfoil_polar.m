%% Drag Polar for Airfoil
% Using xfoil for NACA 23015, gather and develop the Lift curve, the Drag
% curve, and Cd_0 and Zero-lift AoA

[dta,~,~]=importdata(airfoil_polar_file);

alfa=dta.data(:,clms(1));
cl=dta.data(:,clms(2));
CD=dta.data(:,clms(3));
cm=dta.data(:,clms(4));

Cla=griddedInterpolant(alfa(4:end),cl(4:end),'spline','none');
Cda=griddedInterpolant(alfa(4:end),CD(4:end),'spline','none');
Cma=griddedInterpolant(alfa(4:end),cm(4:end),'spline','none');

Cl0=fzero(@(a) Cla(a),[-10 0]);
Cd0=fminsearch(@(a) Cda(a),0);
Clmax=fminsearch(@(a) -Cla(a),20);