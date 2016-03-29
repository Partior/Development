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

%% Optimizing RPM
package={Cr_T;Tk_T;Cr_P;Tk_P};

% setup numeric curve for max thrust by takeoff props. We don't want to
% have to optimize every single call.
[vel,hel]=meshgrid(linspace(0,300,20),linspace(0,45e3,2));
op_rpm_tk=zeros(2,20,2);
wb=waitbar(0,'Processing Takeoff Props');
for ia=1:2
    waitbar((ia-1)/2,wb)
    parfor ib=1:20
        tmp=opmt_rpm_pow_2(vel(ia,ib),hel(ia,ib),package,2,75);
        op_rpm_tk(ia,ib,:)=tmp(1:2);
    end
%     for id=1:1
%         [~,in]=findpeaks(op_rpm_tk(ia,:,1));
%         for ic=1:length(in)
%             ind=max(in(ic)+([-2-1,1,2]),1);
%             ind=min(ind,150);
%             op_rpm_tk(ia,in(ic),1)=mean(op_rpm_tk(ia,ind,1));
%             op_rpm_tk(ia,in(ic),2)=mean(op_rpm_tk(ia,ind,2));
%         end
%     end
end
oprpm_TK=griddedInterpolant(vel',hel',op_rpm_tk(:,:,1)','linear','nearest');
oppit_TK=griddedInterpolant(vel',hel',op_rpm_tk(:,:,2)','linear','nearest');

waitbar(0,wb,'Processing Cruise Props')
[vel,hel]=meshgrid(linspace(0,500,100),linspace(0,45e3,10));
% Setup numeric curve for max thrust by cruise props
for ia=1:10
    waitbar((ia-1)/10,wb)
    parfor ib=1:100
        op_rpm_cr(ia,ib)=opmt_rpm_pow(vel(ia,ib),hel(ia,ib),package,1,300);
    end
end
close(wb)
oprpm_CR=griddedInterpolant(vel',hel',op_rpm_cr','linear','nearest');