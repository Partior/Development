equations_wash  % sets up lift and drag functions

% Lift for the entire airplane will be approximated as the lift for the
% airfoil alone with imperical factor

%% Domain and Constants
% Plotting a modified V-H Diagram
% Plot various number of engines at 100 and 50% power levels

resol=20;
[m_msh,h_msh]=meshgrid(linspace(0.1,0.5,resol),linspace(0,40e3,resol));
taoa=zeros(resol);
pl=zeros(resol);
% started at 0.1 mach to not have to deal with wierd AoAs

% First, power required equation:
plvl=@(aoa,h,v,on) ...
    D(aoa,h,v,on)/(T(v,h)*on/n);
pl=zeros(resol);
gm=zeros(resol);

figure(2); clf; hold on

prim=[0.5 1];
supp=[0.1:0.1:0.4,0.6:0.1:.9];
clr=['k','b','c','g','y','r'];

pll=gcp('nocreate');
if isempty(pll)
    parpool('local')
end

%% Execution
wb=waitbar(0,'Waiting');
for ne=[2,4,6,8]
    subplot(2,2,ne/2); hold on
    for ita=1:resol
        waitbar(ita/40,wb,sprintf('Waiting, %g',ne))
        parfor itb=1:resol
            hi=h_msh(ita,itb);
            vi=m_msh(ita,itb)*a(h_msh(ita,itb));
            taoa(ita,itb)=fsolve(@(rr) L(rr,hi,vi,ne)-W0(0),0,optimoptions('fsolve','display','off'));
            if isnan(taoa(ita,itb))
                pl(ita,itb)=NaN;
                gm(ita,itb)=NaN;
            else
                pl(ita,itb)=plvl(taoa(ita,itb),hi,vi,ne);
                gm(ita,itb)=gmma(taoa(ita,itb),hi,vi,ne);
            end
        end
    end
    
    pl_plot=reshape(pl(imag(pl)==0),size(pl));
    
    cli=clr(ne/2);
    [~,h_m]=contour(m_msh,h_msh/1e3,pl_plot,prim);
    set(h_m,'LineColor','k','LineStyle','-','LineWidth',1.5,...
        'ShowText','on','LabelSpacing',400);
    [~,h_s]=contour(m_msh,h_msh/1e3,pl_plot,supp);
    set(h_s,'LineColor','k','LineStyle',':','LineWidth',1,...
        'LineWidth',0.1);
    [~,hg]=contour(m_msh,h_msh/1e3,gm/5280,0.1:0.1:1.5);
    set(hg,'LineColor','r','LineStyle','-.','LineWidth',1,...
        'ShowText','on','LabelSpacing',400);
    
    [~,hs]=contour(m_msh,h_msh/1e3,m_msh.*a(h_msh),[250,300]*1.4666);
    set(hs,'LineColor','c','LineStyle',':','LineWidth',1.5);
    
    grid on
    
    xlabel('Mach, with \color{cyan}250mph')
    ylabel('Altitude, 1,000 ft')
    title([sprintf('%g Engines',ne),', Power Setting, \color{red} Miles per lbs fuel'])
    
end
close(wb)