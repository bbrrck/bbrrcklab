function writeCURVE(filename,V,E)
%%%
%%% writeCURVE export curve network in the format of [Zhuang13]
%%% see http://www.cse.wustl.edu/~zoum/projects/CycleDisc/
%%%
% Curve file(*.curve): 
% 
% ---------------------------
% 
% The first line of the .curve file stores the number of curves. Each curve is formed by firstly some curve information, then followed by the coordinate of each point on that curve. For each curve, the first line is the curve information, which has three values: the number of points on that curve, whether the curve is open or closed (not used, you can put any integer there), and the curve Capacity (not used, you can put any integer there). 
% 
% 
% 
% An example:
% 
% 
% 1  258                             // number of curves
% 2  3 0 2                           // for the first curve, number of points is 3 
% 3  -0.285999 0.110215 0.028084     // coordinate of the first point on this curve
% 4  -0.288441 0.110215 0.0371736    // coordinate of the second point on this curve
% ...
    
    % number of curves
    nc = max(E(:,3));
    
    % open file
    f = fopen(filename,'w');

    % first line : number of segments
    fprintf(f,'%d\n',nc);
    
    for i = 1:nc
        
        % edges of the curve
        e = E(E(:,3)==i,1:2);
        
        % sorted points on the curve
        k = [e(:,1); e(end,2)];
        
        % number of points on the curve
        np = length(k);
        
        % print number of points in the curve
        fprintf(f,'%i 0 2\n',np);
        
        % print curve points
        fprintf(f,[repmat(' %+0.8f',1,3),'\n'],V(k,:)');
    end
    % close file
    fclose(f);
    
    
    