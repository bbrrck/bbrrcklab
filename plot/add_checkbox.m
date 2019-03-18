function gdata = add_checkbox(handles,f,checkboxstr,varargin)

  % params
  wide  = 150;
  tall  =  16;
  move  =  25;
  fsize =  16;
  fname = 'Inconsolata';

  % helper function : toggle checkbox
  toggle_val = {'off','on'};
  toggle_fn  = @(CB,H) cellfun( @(h) set(h,'Visible',toggle_val{CB.Value+1}), H );
  
  % make sure the handles are a cell array
  if ~iscell(handles), handles = {handles}; end

  % retrieve gui data
  gdata = guidata(f);
  % number of objects
  nh = length(gdata);    
  
  % if no plot objects, get initial position
  if nh==0
      for c = get(f,'Children')'
          if isa(c,'matlab.ui.control.UIControl')
             if strcmp(c.Style,'checkbox')
                  move = max(move,c.Position(2));
              end
          end
      end
      % initial position
      pos = [10 tall+move wide tall];
  else
      for i=1:nh
      % does checkbox exist?
          if strcmp( checkboxstr, gdata(i).cb.String )
            % if yes, delete the plot(s)
            cellfun( @(h) delete(h), gdata(i).handles );
            % save handle to new plot
            gdata(i).handles = handles;
            % save callback to toggle the new plot
            gdata(i).cb.Callback = @(cb,~,~) toggle_fn(cb,handles);
            % toggle the new plot
            toggle_fn(gdata(i).cb,handles);
            % save data to gui
            guidata(f,gdata);
            return;
          end
      end
      % position w.r.t. the previous one
      pos = gdata(end).cb.Position + [0 tall 0 0];
  end

  % checkbox does not exist, add new
  gdata(nh+1).handles = handles;
  gdata(nh+1).cb = uicontrol(f,...
      'BackgroundColor', 'w',  ...
      'String',           checkboxstr,        ...
      'Style',           'checkbox',          ...
      'Units',           'pixels',            ...
      'FontSize',         fsize,              ...
      'FontName',         fname,              ...
      'Position',         pos,                ...
      'Callback',         @(cb,~,~)           ...
                          toggle_fn(cb,handles) ...
  );
  for i=1:2:nargin-4
      set( gdata(nh+1).cb, varargin{i}, varargin{i+1});
  end

  toggle_fn(gdata(nh+1).cb,handles);
  guidata(f,gdata);
  
  