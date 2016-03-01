%% Plotter
h=0e3;
nn=2;

Pf={Cr_P;Tk_P};
Tf={Cr_T;Tk_T};
nf={n_Pc;n_Pt};

vll=@(m) a(h)*m;

figure(1);
clf
fplot(@(m) opmt_rpm_pow(vll(m),h,package,nn),[0 0.5],5e-4)
xlim([0 0.5])
xlabel('Mach')
ylabel('Optimum RPM')

figure(2);
clf
fplot(@(m) Pf{nn}(vll(m),h,opmt_rpm_pow(vll(m),h,package,nn))/550,[0 0.5],5e-4)
xlim([0 0.5])
xlabel('Mach')
ylabel('SHP input: hp')

figure(3);
clf
fplot(@(m) nf{nn}(j_ratio(vll(m),opmt_rpm_pow(vll(m),h,package,nn),Rmax(nn)))/100,[0 0.5],5e-4)
xlim([0 0.5])
xlabel('Mach')
ylabel('\eta_P')

figure(4);
clf
fplot(@(m) Tf{nn}(vll(m),h,opmt_rpm_pow(vll(m),h,package,nn)),[0 0.5],5e-4)
xlim([0 0.5])
xlabel('Mach')
ylabel('Thrust, lbf')