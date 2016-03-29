veldom=0:2:350;
hdom=0:1e3:10e3;
pow_ava=75;
opit=1.55*ones(length(hdom),length(veldom));
orpm=zeros(length(hdom),length(veldom));
wb=waitbar(0,'Processing Takeoff Props');
for ita=1:length(hdom)
    waitbar((ita-1)/length(hdom),wb)
    h=hdom(ita);
    for itr=1:length(veldom)
        orpm(ita,itr)=fzero(@(r) Tk_P(veldom(itr),h,r,1.55)/550-pow_ava,2000,optimset('display','off','TolX',1e-4));
        if orpm(ita,itr)>2500;
            orpm(ita,itr)=2500;
            opit(ita,itr)=fzero(@(p) Tk_P(veldom(itr),h,2500,p)/550-pow_ava,2,optimset('display','off','TolX',1e-4));
        end
    end
end
close(wb)