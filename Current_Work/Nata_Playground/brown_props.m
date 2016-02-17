%% Propellor Performance
% Combine the mach-thrust curves of various rpm regimes to produce a
% mach-thrust curve for optimum thrust across the operating spectrum. Also
% correlate power requried at various rpm-thrust-mach settings.

% Determine and record the peaks of various rpm regimes
% n=number of numeric outputs for rpm
clf
hold on
n=[0.925,1.11,1.295];
alt=[0 1e4];
for italt=1:2
for ita=1:length(n)
%     data=importdata('filename_n.txt'); % get data for the mach-thrust values
    data_m=nonzeros(data(:,ita*2-1+(italt-1)*6)); % get mach axis data
    data_thrust=nonzeros(data(:,ita*2+(italt-1)*6));  % get correlating thrust data
    rpmlvl(ita)=n(ita); % rpm for the output 'n'
    M0(ita)=0;
    T0(ita)=data_thrust(1); % static thrust for output 'n'
    
    % using findpeaks function under signal analysis, find the maxima peaks
    % for the data
    [tp_t,mp_t]=findpeaks(data_thrust,data_m);
    tp(ita)=tp_t(end);
    mp(ita)=mp_t(end);
    % find the min point
%     [tp_f(ita),mp_f(ita)]=findpeaks(-data_thrust,data_m); % reminder that tp_f needs to be negated
    
    % log the end piont (assume this is maximum for tip-mach purposes
    Tf(ita)=data_thrust(end);
    Mf(ita)=data_m(end);
    
    plot(data_m,data_thrust*0.224809/1e3)
end
end

% plot(mp,tp*0.224809/1e3,'dk') % plot combination of peaks and rpms
xlabel('Mach')
ylabel('Thrust, 1000 lbf')
title('250 SHP @ 10,000 ft, 1000 rpm')