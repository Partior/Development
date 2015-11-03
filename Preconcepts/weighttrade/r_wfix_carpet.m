assumer

rres=10; wfres=5;
[rg,wf]=meshgrid(linspace(200,1500,rres),linspace(1250,5400,wfres));
figure(2); clf
title('Takeoff Weight: V_c=265 mph')
hold on

for it1=1:wfres
    for it2=1:rres
        R=rg(it1,it2);
        Wfix=wf(it1,it2);
        W_est;
        W(it1,it2)=Wto;
        Wft(it1,it2)=Wf_Wto;
    end
end

W2=zeros(size(W));
sz=size(W);

% Fix Weight Dependant Weight
for a=1:sz(1)
    plot((1:sz(2))+interp1(W(:,1),1:sz(1),W(a,1))-1,W(a,:),'b')
    text(1+interp1(W(:,1),1:sz(1),W(a,1))-1,W(a,1),sprintf('%0.0f',wf(a,1)),...
        'Verticalalignment','middle','horizontalAlignment','right')
end

% Range Dependant Weight
for b=1:sz(2)
    plot((1:sz(1))+interp1(W(1,:),1:sz(2),W(1,b))-1,W(:,b),'b')
    text(1+interp1(W(1,:),1:sz(2),W(1,b))-1,W(1,b),sprintf('%0.0f',rg(1,b)),...
        'Verticalalignment','top','horizontalAlignment','center')
end

set(gca,'XTick',[])
ylabel('Gross Takeoff Weight: W_{TO} lbs')
