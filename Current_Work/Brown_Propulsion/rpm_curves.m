%% What RPM do we use?

%  What is the optimal rpm to use in various circumstances?
% Low speed, max rpm
% High speed, want max rpm or power efficiency?

% Advance Ratio Specifc constraints
min_r=1./(2*diag(Rmax)*[max(dmat.C_P(:,1));max(emat.C_P(:,1))])*60;
% multiply this factor by the velocity (in ft/sec) and get the minimum rpm
% required for zero thrust ( cruise; takeoff)

% rpm for the best propeller efficiency
[~,inc]=max(dmat.n_P(:,2));
[~,int]=max(emat.n_P(:,2));
best_r=1./(2*diag(Rmax)*[dmat.C_P(inc,1);emat.C_P(int,1)])*60;

% Propullsive (after SHP) Power Available: again, in fractions, that way take the number and
% multiply by the Power from the APU, and get Output Power
SHP_C=@(V,h,n) n_motor*n_Pc(j_ratio(V,n,Rmax(1)))/100;
SHP_T=@(V,h,n) n_motor*n_Pt(j_ratio(V,n,Rmax(2)))/100;

%% Optimizing RPM
% input power required (D*V) by this factor to get minimum J_ratio
optopts=optimset('display','none');
min_j=@(Pr) [fzero(@(j) Pr/(n_Pc(j)/100)-Pa,[0.05 dmat.C_P(inc,1)],optopts);
    fzero(@(j) Pr/(n_Pt(j)/100)-Pa,[0.05 emat.C_P(int,1)],optopts)];

% point at which thrust peak is greater that slope point at small j's
[pk_ctc,pk_jc]=findpeaks(dmat.C_T(1:end-1,2),dmat.C_T(1:end-1,1));
[pk_ctt,pk_jt]=findpeaks(emat.C_T(1:end-1,2),emat.C_T(1:end-1,1));
maxlitt_j=[dmat.C_T(find(dmat.C_T(1:end-1,2)>pk_ctc(1),1,'last'),1);
    emat.C_T(find(emat.C_T(1:end-1,2)>pk_ctt(1),1,'last'),1)];

package={pk_jc;pk_jt;Rmax;Cr_T;Tk_T};