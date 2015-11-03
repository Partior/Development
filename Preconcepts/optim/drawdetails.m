<<<<<<< HEAD
    function output_txt = drawdetails(~,evntobj)
        % Used to output custom datatip information, as well as update the detail
        % graphs that show specic information about the selected data.
        disp('We got this far')
        pos = get(evntobj,'Position');
        posout=[interp1(1:length(lbs),lbs,pos(1)-floor(pos(1)/(length(lbs)+1))*(length(lbs)+1)-1),...
            pos(2)];
        output_txt = {['LDmax: ',num2str(LDd(floor(pos(1)/(length(lbs)+1))+1),3)],...
            ['X: ',num2str(posout(1),4)],...
            ['Y: ',num2str(posout(2),4)]};
        
        
        
        
        % Begin graphics
        [Rin,V_cin]=find(optimzd(:,:,LDinfloor(pos(1)/(length(lbs)+1))+1,2)==posout(2));
        
        
        
        assignin('base','R',Rd(Rin));
        assignin('base','V_c',Vd(V_cin);
        assignin('base','LD',LDd(LDind);
        
        keyboard
        cla(aTW)
        cnstr_n
        axes(abse)
=======
    function output_txt = drawdetails(~,evntobj)
        % Used to output custom datatip information, as well as update the detail
        % graphs that show specic information about the selected data.
        disp('We got this far')
        pos = get(evntobj,'Position');
        posout=[interp1(1:length(lbs),lbs,pos(1)-floor(pos(1)/(length(lbs)+1))*(length(lbs)+1)-1),...
            pos(2)];
        output_txt = {['LDmax: ',num2str(LDd(floor(pos(1)/(length(lbs)+1))+1),3)],...
            ['X: ',num2str(posout(1),4)],...
            ['Y: ',num2str(posout(2),4)]};
        
        
        
        
        % Begin graphics
        [Rin,V_cin]=find(optimzd(:,:,LDinfloor(pos(1)/(length(lbs)+1))+1,2)==posout(2));
        
        
        
        assignin('base','R',Rd(Rin));
        assignin('base','V_c',Vd(V_cin);
        assignin('base','LD',LDd(LDind);
        
        keyboard
        cla(aTW)
        cnstr_n
        axes(abse)
>>>>>>> 675761e40a935092eba10cea5d6cb6c685d3e778
    end