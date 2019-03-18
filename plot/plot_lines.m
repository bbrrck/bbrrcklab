function h = plot_lines(X0,X1,opts)

    [n,d] = size(X0);
    assert(d==2 || d==3);
    assert(n==size(X1,1));
    assert(d==size(X1,2));

    if nargin < 3
        opts = struct; 
    end
    
    if isfield(opts,'Color')
      if size(opts.Color,1) == n && n > 1
          opts.Color = repmat(opts.Color,2,1);
      end
    end
    
    V = [X0; X1];
    e = (1:n)';
    E = [e e+n];
    
    h = plot_edges(V,E,opts);

end

