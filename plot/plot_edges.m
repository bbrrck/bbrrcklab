function h = plot_edges(V,E,opts)
    
    [nv,dv] = size(V);
    [~,de] = size(E);
    
    assert(dv==2 || dv==3);
    assert(de==2);

    if dv==2
      V(:,3) = 0;
    end
    
    if nargin < 3
      opts = struct; 
    end
    
    % Extract colors from colormap if available
    if ~isfield(opts,'Color')    && ...
        isfield(opts,'ColorMap') && ...
        isfield(opts,'ColorIndex')
      opts.Color = opts.ColorMap(mod(opts.ColorIndex-1,size(opts.ColorMap,1))+1,:);
    end

    % Defaults
    if ~isfield(opts,'AxHandle'),   opts.AxHandle   = gca;  end
    if ~isfield(opts,'Color'),      opts.Color      = 'k';  end
    if ~isfield(opts,'LineStyle'),  opts.LineStyle  = '-';  end
    if ~isfield(opts,'LineWidth'),  opts.LineWidth  =   1;  end

    % Drawing lines as degenerate triangles is faster
    % See http://www.alecjacobson.com/weblog/?p=3829
    h=trisurf(E(:,[1 1 2]), V(:,1), V(:,2), V(:,3));
    h.FaceColor = 'none';   
    
    % set line width
    h.LineWidth = opts.LineWidth;
    h.LineStyle = opts.LineStyle;
    
    % set the color according to the number of colors supplied
    if nv == size(opts.Color,1)
      h.EdgeColor       = 'interp';
      h.FaceVertexCData = opts.Color;
    else
      h.EdgeColor       = opts.Color;
    end
end