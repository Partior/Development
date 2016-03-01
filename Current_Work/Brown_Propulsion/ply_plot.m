%% Plotter

figure(1)
clf
[x1,y1]=fplot(@(v) [Cr_T(v,0,2000),Cr_T(v,0,opmt_rpm(v,package,1))],[0 500]);
[x2,y2]=fplot(@(v) opmt_rpm(v,package,1),[0 500]);
plotyy(x1,y1,x2,y2)