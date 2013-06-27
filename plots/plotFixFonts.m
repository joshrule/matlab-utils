function fixFonts(axishandle,fontsize,linewidth,fontname)
% fixFonts(axishandle,fontsize,linewidth,fontname)
%
% Tweak plot aesthetics by altering line thickness and font size.
%
% axishandle: axis handle, the handle to the axis to be altered
% fontsize: scalar, the font size to use on 'axishandle'
% linewidth: scalar, the thickness in pixels of lines to use on 'axishandle'
% fontname: string, the font to use on 'axishandle'
    if (nargin < 1) axishandle = gca; end;
    if (nargin < 2) fontsize   = 20;  end;
    if (nargin < 3) linewidth  = 3;   end;
    if (nargin < 4) fontname = 'Bitstream Vera Sans'; end;

    set(axishandle,'LooseInset',get(axishandle,'TightInset'))
    set(axishandle,'FontSize',fontsize,'FontWeight','bold','FontName',fontname);
    set(get(axishandle ,'xlabel'),'FontName',fontname, ...
      'FontSize',fontsize,'FontWeight','bold');
    set(get(axishandle ,'ylabel'),'FontName',fontname, ...
      'FontSize',fontsize,'FontWeight','bold');
    set(get(axishandle ,'title'),'FontName',fontname, ...
      'FontSize',fontsize,'FontWeight','bold');
    
    set(axishandle ,'Linewidth',linewidth);
    set(findobj(axishandle ,'Type','line'),'LineWidth',linewidth);
    set(findobj(axishandle ,'Type','text'),'FontName',fontname);
    set(findobj(axishandle ,'Type','text'),'FontWeight','bold');
    set(findobj(axishandle ,'Type','text'),'FontSize',fontsize);
end
