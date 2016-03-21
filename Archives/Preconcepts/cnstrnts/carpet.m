assumer

[rd,vd]=meshgrid(linspace(800,1500,20),linspace(250,300,10));
figure(3); clf
hold on

for it1=1:10
    for it2=1:20
        R=rd(it1,it2);
        V_c=vd(it1,it2);
        W_est;
        W(it1,it2)=Wto;
    end
end

W2=zeros(size(W));
sz=size(W);
[xadj,~]=meshgrid(1:20,1:10);

% Velocity Dependant Weight
for a=1:sz(1)
    plot((1:sz(2))+interp1(W(:,1),1:sz(1),W(a,1))-1,W(a,:),'b')
    text(1+interp1(W(:,1),1:sz(2),W(a,1))-1,W(a,1),sprintf('%0.0f',vd(a,1)),...
        'Verticalalignment','top','horizontalAlignment','center')
end

% Range Dependant Weight
for b=1:sz(2)
    plot((1:sz(1))+interp1(W(1,:),1:sz(2),W(1,b))-1,W(:,b),'b')
    text(1+interp1(W(1,:),1:sz(2),W(1,b))-1,W(1,b),sprintf('%0.0f',rd(1,b)),...
        'Verticalalignment','middle','horizontalAlignment','right')
end

set(gca,'XTick',[])
ylabel('Gross Takeoff Weight: W_{TO} lbs')
title('Takeoff Weight from Cruise Velocity and Range')