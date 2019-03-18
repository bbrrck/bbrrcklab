function [P0,P1,Cl] = trace_streamlines_frame_field(RootsAngle,T,F,V,options)

    if nargin < 5
        options = struct;
    end
    
    if ~isfield(options,'N')
        options.N = 4; % cross field by default
    end
    
    if ~isfield(options,'stepsize')
        l = edge_lengths(V,F);
        options.stepsize = min(l(:));
    end
    
    if ~isfield(options,'numlines')
        options.numlines = 1e3;
    end
        
    if ~isfield(options,'maxiter')
        options.maxiter  = 500;
    end
    
    if ~isfield(options,'rng_seed')
        options.rng_seed = 5678;
    end
    
    % stepsize for Runge-Kutta
    stepsize = options.stepsize;
    % number of lines to be traced
    numlines = options.numlines;
    % max number of iterations for a single line
    maxiter = options.maxiter;
    % seed
    rng_seed = options.rng_seed;
    
    % number of vertices in the triangulation
    nv = max(F(:));
    
    % reset
    rng(rng_seed);

    % random init seeds
    ax = min( V(:,1) );
    bx = max( V(:,1) );
    ay = min( V(:,2) );
    by = max( V(:,2) );

    x = ax + (bx - ax) * rand(numlines,1);
    y = ay + (by - ay) * rand(numlines,1);
    seed = [x y];

    % random init directions (angles)
    angl = pi * (-1 + 2*rand(numlines,1));
    
    if isfield(options,'seedPoints') && isfield(options,'seedAngles')
        seed = [seed; options.seedPoints];
        angl = [angl; options.seedAngles];
    end
    
    idx = 1:size(seed,1);
    
    % print message
%     fprintf([
%         '\tstepsize = %f\n'...
%         '\tnumlines = %d\n'...
%         '\tmaxiter  = %d\n'],...
%         stepsize,length(seed),maxiter);

    % init lines
    P0 = zeros(1e6,2);
    P1 = zeros(1e6,2);
    Cl = zeros(1e6,1);
    np = 0;
    
    % iterate
    ns = length(angl);
    iter = 0;
    while ns > 0
        iter = iter + 1;
        if iter > maxiter
            break
        end
        
        %% 1. locate the point in a triangulation
        [f,~] = pointLocation(T,seed);
        % remove points which are not in the triangulation
        to_remove = isnan(f);
        f    (to_remove)   = [];
        seed (to_remove,:) = [];
        angl (to_remove,:) = [];
        idx  (to_remove)   = [];
        ns = size(seed,1);
        
        %% 2. select frames
        roots_angle = RootsAngle(f,:);
       
        %% 3. find new direction closest to the old direction
        diff = roots_angle - angl;
        % to [0,2*pi]
        diff = mod(diff,2*pi);
        % cyclic distance
        diff = min(diff,2*pi-diff);
        % which root is closest?
        [~,cols] = min(diff,[],2);
        
        rows = 1:length(angl);
        ind = sub2ind(size(roots_angle),rows(:),cols(:));
        angl = roots_angle(ind);
        
        %% 4. advance in the new direction  
        new_seed = seed + stepsize * [cos(angl), sin(angl)];
        
        %% 5. save
        P0(np+(1:ns),1:2) = seed;
        P1(np+(1:ns),1:2) = new_seed;
        Cl(np+(1:ns)) = idx;
        np = np+ns;
        
        %% 6. repeat
        seed = new_seed;
    end
    
    P0(np+1:end,:) = [];
    P1(np+1:end,:) = [];
    Cl(np+1:end)   = [];
    
    