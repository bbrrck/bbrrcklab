function h = plot_curve(V,opts)

    [nv,dv] = size(V);
    
    assert( dv==2 || dv==3 );

    if nargin < 2
        opts = struct; 
    end

    if isfield(opts,'closed'),  opts.Closed = opts.closed; end
    if ~isfield(opts,'Closed'), opts.Closed = 0;              end

    if opts.Closed
      E = [
        1:nv
        2:nv 1
      ];
    else
      E = [
        1:nv-1
        2:nv
      ];
    end
    E = E';
    h = plot_edges(V,E,opts);

end

