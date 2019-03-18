function add_plot_controls(fig)

  function callback_reset(~,~,~)
    gca(fig);
    axis equal;
    zoom out;
  end

  function callback_show_text(~,~,~)
    for h = get(gca(fig),'Children')'
      if strcmp(h.Type,'text')
        h.Visible = 'on';
      end
    end
  end

  function callback_hide_text(~,~,~)
    for h = get(gca(fig),'Children')'
        if strcmp(h.Type,'text')
          h.Visible = 'off';
        end  
    end
  end

  function callback_bigger_text(~,~,~)
    for h = get(gca(fig),'Children')'
        if strcmp(h.Type,'text')
          h.FontSize = h.FontSize+2;
        end  
    end
  end

  function callback_smaller_text(~,~,~)
    for h = get(gca(fig),'Children')'
        if strcmp(h.Type,'text')
          if h.FontSize > 2
            h.FontSize = h.FontSize-2;
          end
        end  
    end
  end
  
  strings   = {       ...
      'Reset axes'    ...
    , 'Show Text'     ...
    , 'Hide Text'     ... 
    , 'Text++'        ...
    , 'Text--'        ... 
  };
  callbacks = {             ...
      @callback_reset       ...
    , @callback_show_text   ...
    , @callback_hide_text   ...
    , @callback_bigger_text   ...
    , @callback_smaller_text   ...
  };
  
  xoff  = 10;
  yoff  = 10;
  wide  = 120;
  tall  = 25;
  
  % delete all buttons
  delete_count = 0;
  for c = get(fig,'Children')'
    if isa(c,'matlab.ui.control.UIControl')
       if strcmp(c.Style,'pushbutton')
         delete_count = delete_count+1;
         delete(c);
        end
    end
  end
  if delete_count>0
    fprintf('deleted %d push buttons\n',delete_count);
  end
  
  for i=1:length(strings)    
    uicontrol( fig                              ...
      ,'Callback',    callbacks{i}              ...
      ,'String',      strings{i}                ...
      ,'FontSize',    20                        ...
      ,'FontName',    'Inconsolata'             ...
      ,'Position',    [xoff yoff wide tall]     ...
      ,'Style',       'PushButton'              ...
    );
    xoff = xoff + wide;
  end
  
end
