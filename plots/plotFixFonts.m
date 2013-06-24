function fixFonts(axishandle,fontsize,linewidth)
    if nargin < 1
        axishandle = gca;
    end
    if nargin < 2
        fontsize = 20;
    end
    if nargin < 3
        linewidth = 3;
    end
    set(axishandle,'LooseInset',get(axishandle,'TightInset'))
    fontname = 'Bitstream Vera Sans';
    set(axishandle ,'FontSize',fontsize,'FontWeight','bold','FontName',fontname);
    set(get(axishandle ,'xlabel'),'FontName',fontname,'FontSize',fontsize,'FontWeight','bold');
    set(get(axishandle ,'ylabel'),'FontName',fontname,'FontSize',fontsize,'FontWeight','bold');
    set(get(axishandle ,'title'),'FontName',fontname,'FontSize',fontsize,'FontWeight','bold');
    
    set(axishandle ,'Linewidth',linewidth);
    set(findobj(axishandle ,'Type','line'),'LineWidth',linewidth);
    set(findobj(axishandle ,'Type','text'),'FontName',fontname);
    set(findobj(axishandle ,'Type','text'),'FontWeight','bold');
    set(findobj(axishandle ,'Type','text'),'FontSize',fontsize);

end
