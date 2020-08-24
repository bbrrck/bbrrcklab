function screenshot(varargin)
%
% Save current figure.
%
% Params
% - name:
% - path:
% - fig:
% - dpi: resolution (dpi) of final graphic
%
% Tibor Stanko 2015-2016
%
    dpi = 100;
    path = '~/postdoc-screenshots/';
    filename = ['Screenshot ' datestr(now,'yyyy-mm-dd at HH.MM.SS')];
    figh = gcf;
    for i = 1:2:length(varargin)
        name  = varargin{i};
        value = varargin{i+1};
        switch name
            case 'filename'
              filename = value;
            case 'dpi'
                dpi = value;
            case 'fig'
                figh = value;
            case 'path'
                path = value;
            otherwise
                warning(['wrong param ' name])
        end
    end
    filename = [filename '.png'];
    if ~exist(path,'dir')
        mkdir(path);
    end
    tic;
    figpos = getpixelposition( figh );
    resolution = get(0,'ScreenPixelsPerInch');
    set( figh ,...
        'paperunits','inches',...
        'papersize', figpos(3:4)/resolution,...
        'paperposition',[0 0 figpos(3:4)/resolution]);

    print( figh, fullfile(path,filename), ...
        '-dpng',['-r',num2str(dpi)],'-opengl');
    fprintf('\nsaved figure to %s [%i sec]\n',[path filename],toc);

%     dpi = 300;
%     filename = datestr(now,31);
%     filename = strrep(filename,' ','_');
%     filename = strrep(filename,':','-');
%     %path = assetPath('png');
%     path = '/home/bbrrck/Pictures/';
%     figh = gcf;
%     for i = 1:2:length(varargin),
%         name  = varargin{i};
%         value = varargin{i+1};
%         switch name,
%             case 'dpi'
%                 dpi = value;
%             case 'name'
%                 filename = value;
%             case 'path'
%                 path = value;
%             case 'fig'
%                 figh = value;
%             otherwise
%                 warning(['wrong param ' name])
%         end
%     end
%     filename = [filename '.png'];
%     if ~exist(path,'dir'),
%         mkdir(path);
%     end
%     tic;
%     figpos = getpixelposition( figh );
%     resolution = get(0,'ScreenPixelsPerInch');
%     set( figh ,...
%         'paperunits','inches',...
%         'papersize', figpos(3:4)/resolution,...
%         'paperposition',[0 0 figpos(3:4)/resolution]);
%
%     print( figh, fullfile(path,filename), ...
%         '-dpng',['-r',num2str(dpi)],'-opengl');
%     fprintf('\nsaved figure to %s [%i sec]\n',[path '/' filename],toc);
