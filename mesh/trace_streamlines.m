function [P0,P1] = trace_streamlines(U,T,F,V,options)

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
    
    % print message
    fprintf([
        '\tstepsize = %f\n'...
        '\tnumlines = %d\n'...
        '\tmaxiter  = %d\n'],...
        stepsize,length(seed),maxiter);

    % init lines
    P0 = zeros(1e6,2);
    P1 = zeros(1e6,2);
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
        [f,bw] = pointLocation(T,seed);
        % remove points which are not in the triangulation
        to_remove = isnan(f);
        f    (to_remove)   = [];
        bw   (to_remove,:) = [];
        seed (to_remove,:) = [];
        angl (to_remove,:) = [];
        ns = size(seed,1);
        
        %% 2. interpolate representatives via barycentric coords
        % a) constant vector per face
        %newa = 0.25 * anF(f);

        % b) barycentric interpolation
        S = (1:ns)';
        W = sparse([S S S],F(f,:),bw,ns,nv);
        Us = W * U;
        new_angl = angle(Us) ./ options.N;
       
        %% 3. find new direction closest to the old direction
        dangle = angl - new_angl;
        ks = dangle / (2*pi/options.N);
        k = round(ks);
        
        %% 4. advance in the new direction
        angl = new_angl + k*(2*pi/options.N);     
        new_seed = seed + stepsize * [cos(angl) sin(angl)];
        
%         [f,~] = pointLocation(T,new_seed);
%         valid = ~isnan(f);        
%         ns = sum(valid);
%         S = (1:ns)';
        
        %% 5. save
        P0(np+S,1:2) = seed;
        P1(np+S,1:2) = new_seed;
%         P0(np+S,1:2) = seed(valid,:);
%         P1(np+S,1:2) = new_seed(valid,:);
        np = np+ns;
        
        %% 6. repeat
        seed = new_seed;
    end
    
    P0(np+1:end,:) = [];
    P1(np+1:end,:) = [];
    
    