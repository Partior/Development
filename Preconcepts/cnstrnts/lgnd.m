<<<<<<< HEAD
function lgnd(src,clldata)
%% For kicks and giggles of the Window resizing function
szf=get(src,'Position');
chld=get(gcf,'Children');
% Legend
if szf(3)<6.5 || szf(4)<4.5
    lgp='eastoutside';
else
    lgp='north';
end   
chld(1).Location=lgp;

% Line Width
if szf(3)<6.5 || szf(4)<4.5
    wd=0.5;
elseif szf(3)<10 || szf(4)<8
    wd=1.15;
else
    wd=2;
end

cld=get(gca,'Children');
for it=1:length(cld)
    if strcmp(cld(it).Type,'line')
        if cld(it).LineWidth==wd
            break
        end
        cld(it).LineWidth=wd;
    end
end

=======
function lgnd(src,clldata)
%% For kicks and giggles of the Window resizing function
szf=get(src,'Position');
chld=get(gcf,'Children');
% Legend
if szf(3)<6.5 || szf(4)<4.5
    lgp='eastoutside';
else
    lgp='north';
end   
chld(1).Location=lgp;

% Line Width
if szf(3)<6.5 || szf(4)<4.5
    wd=0.5;
elseif szf(3)<10 || szf(4)<8
    wd=1.15;
else
    wd=2;
end

cld=get(gca,'Children');
for it=1:length(cld)
    if strcmp(cld(it).Type,'line')
        if cld(it).LineWidth==wd
            break
        end
        cld(it).LineWidth=wd;
    end
end

>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
end