%% Thrust Curve
% AS OF 29 FEB
curve_read

% cruise thrust
Cr_T=@(V,h,n) C_Tc(j_ratio(V,n,Rmax(1)))*p(h).*(n/60).^2*(2*Rmax(1))^4;
% Takeoff thrust
Tk_T=@(V,h,n,pt) C_Tt(j_ratio(V,n,Rmax(2)),pt)*p(h).*(n/60).^2*(2*Rmax(2))^4;

% Power Coefficient
Cr_P=@(V,h,n) C_Pc(j_ratio(V,n,Rmax(1)))*p(h).*(n/60).^3*(2*Rmax(1))^5;
Tk_P=@(V,h,n,pt) C_Pt(j_ratio(V,n,Rmax(2)),pt)*p(h).*(n/60).^3*(2*Rmax(2))^5;

SHP_C=@(V,h,n) n_motor*n_Pc(j_ratio(V,n,Rmax(1)))/100;
SHP_T=@(V,h,n) n_motor*n_Pt(j_ratio(V,n,Rmax(2)))/100;

package={Cr_T;Tk_T;Cr_P;Tk_P};
%% Test to see if we have already determined optimum rpm
if exist('Brown_Propulsion\RPM\rpm_curves.mat','file')
    load('Brown_Propulsion\RPM\rpm_curves.mat')
    return
end
%% Optimizing RPM
% setup numeric curve for max thrust by takeoff props. We don't want to
% have to optimize every single call.
veldom=0:5:450;
hdom=0:5e3:45e3;

pow_ava=[150,70];

opit=1.55*ones(length(hdom),length(veldom));
orpm=zeros(length(hdom),length(veldom));
wb=waitbar(0,'Processing Takeoff Props');
for ita=1:length(hdom)
    waitbar((ita-1)/length(hdom),wb)
    h=hdom(ita);
    for itr=1:length(veldom)
        orpm(ita,itr)=fzero(@(r) Tk_P(veldom(itr),h,r,1.55)/550-pow_ava(1),2000,optimset('display','off','TolX',1e-4));
        if orpm(ita,itr)>2500;
            orpm(ita,itr)=2500;
            opit(ita,itr)=fzero(@(p) Tk_P(veldom(itr),h,2500,p)/550-pow_ava(1),2,optimset('display','off','TolX',1e-4));
            if isnan(opit(ita,itr))
                opit(ita,itr)=1.55;
            end
        end
    end
end
oprpm_TK=griddedInterpolant({veldom,hdom},orpm','linear','nearest');
oppit_TK=griddedInterpolant({veldom,hdom},opit','linear','nearest');

waitbar(0,wb,'Processing Cruise Props')
% Setup numeric curve for max thrust by cruise props
for ia=1:length(hdom)
    waitbar((ia-1)/length(hdom),wb)
    parfor ib=1:length(veldom)
        op_rpm_cr(ia,ib)=opmt_rpm_pow(veldom(ib),hdom(ia),package,1,pow_ava(2));
    end
end
close(wb)
oprpm_CR=griddedInterpolant({veldom,hdom},op_rpm_cr','linear','nearest');

save('Brown_Propulsion\RPM\rpm_curves.mat','oprpm_TK','oppit_TK','oprpm_CR');