function h = plot_vectors(P,V,options)

    [n,d] = size(P);
    
    assert(d==2 || d==3);
    assert(n==size(V,1));
    assert(d==size(V,2));

    if nargin < 3
        options = struct; 
    end

    if ~isfield(options,'LineStyle'),  options.LineStyle='-'; end
    if ~isfield(options,'LineWidth'),  options.LineWidth=1;   end
    if ~isfield(options,'Color'),      options.Color='k';     end
    if ~isfield(options,'Scale'),      options.Scale=1;       end
    if ~isfield(options,'AxHandle'),   options.AxHandle=gca;  end

    % scale
    if length( options.Scale ) == size(V,1) && size(V,1) > 1
        l = diag( options.Scale );
    elseif length( options.Scale ) == 1
        l = options.Scale;
    else
        error('Invalid length of options.Scale')
    end
    
    % endpoints        
    L = [
        P
        P + l*V
    ];
    if d==2
        L(:,3) = 0;
    end

    % draw as degenerate triangles
    e = (1:n)';
    F = [e e e+n];
    h=trisurf(...
        F,...
        L(:,1),...
        L(:,2),...
        L(:,3));
    
    h.LineWidth=options.LineWidth;
    h.FaceColor='none';
    
    if size(options.Color,1) == n && n > 1
        h.EdgeColor       = 'interp'; 
        h.FaceVertexCData = [options.Color; options.Color];
    else
        h.EdgeColor        = options.Color;
    end