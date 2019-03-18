function processBLENDERNET(filename)
% processBlenderCurves
%   process network exported from Blender to get normals
%   additional obj needed
%     if nargin < 2,
%         dir='data/';
%     end
%     if nargin < 1,
%         name='lilium.arbitrary';
%         name='gamepad';
%         name='sphere';
%     end

    clc
    
    %% read blender net
    [V,N,curves] = readBLENDERNET(filename);
    
    %% init figure  
    f=figure(11);f.NumberTitle='off';f.Color='w';f.Name='Process Blender curves';clf;
    a=gca;a.Clipping='off';cla;hold on;axis off;axis equal;
    plotoptions.bdcurves.Color  = [ 0 0.2 0.6];
    plotoptions.incurves.Color  = [ 0 0.6 0.2];
    plotoptions.nodes.Color     = [ 0.6 0.2 0];
    plotoptions.nodes.MarkerSize= 30;
    
    %% Put edges into a common matrix
    rawE = zeros(1e5,2);
    ec = 0;
    for curve = curves,
        
        % how many edges in this curve
        en = size(curve.rawE,1);
        
        % store edges in rawE
        rawE(ec+(1:en),:) = curve.rawE(:,1:2);
        
        % increment
        ec = ec + en;
    end
    rawE(ec+1:end,:) = [];
    
    %% Detect nodes
    disp('Detecting nodes')
    
    % method 1 : multiplicities via sparse
    vi = rawE(:,1:2);
    vi = vi(:);
    mult = sparse(vi,1,1);
    nodes = find(mult > 2);
    nodes = nodes(:)';
    
    % method 2 : differences of consecutive tangents
    % for each vertex
    % look at the adjacent edges = tangents
    % if some two of them are not colinear,
    % this is a node
    %     for v = 1:length(V),
    %         [e,~] = find( E(:,1:2)==v );
    %         v1 = E(e,1);
    %         v2 = E(e,2);
    %         T = V(v1,:) - V(v2,:);
    %         T = normr(T);
    %         for i = 1 : size(T,1)-1,
    %             if ismember(v,nodes), break; end
    %             for j = i+1 : size(T,1),
    %                 if ismember(v,nodes), break; end
    %                 if abs( dot( T(i,:), T(j,:)) ) < 0.1,
    %                     fprintf('  %d: i=%d, j=%d\n',v,i,j);
    %                     nodes(end+1) = v;
    %                 end
    %             end
    %         end
    %     end
    
    %% check if nodes detected correctly
    if isempty(nodes),
        error('No nodes detected.')
    end
    fprintf('%d nodes detected\n',length(nodes));
    fprintf([repmat('%5d',1,5) '\n'],nodes);
    fprintf('\n');

    % plot nodes
    plotPoints3( V(nodes,:), plotoptions.nodes );
    
    %% Order the edges inside curves
    clear rawE;
    % 1 : startvertex of the edge
    % 2 : endvertex of the edge
    % 3 : curve number
    % 4 : order of edge in the curve
    % 5 : boundary=1, interior=0
    E = zeros(1e5,5);
    shift=0;
    s=0;
    
    for c=1:length(curves),   
        
        fprintf('c=%d\n',c);
        
        % unordered edges
        rawE = curves(c).rawE;
        % edge count
        ec = size(rawE,1);
        
        % init ordered edges
        cE = zeros(ec,5);
        %cE(:,3) = c;
        %cE(:,4) = 1:ec;
        
        % init matrix of free edges
        free = ones(ec,2);
        
        % where are the nodes?
        rawNodes = ismember(rawE(:,1:2),nodes);
        
        while true,
            
            % find a free node
            freenodes = rawE(free & rawNodes);
            freenodes = freenodes(:);
            
            if isempty(freenodes),
                disp('break outer while');
                break; % while
            end
            
            s=s+1;
            
            S = sparse(freenodes,1,1);
            % if open, we need to make sure we get the endnode!
            % solution:
            % get a node with minimal valence
            % get unique elements and multiplicities
            [ufreenodes,~,mult] = find(S);
            endnode = ufreenodes( mult==min(mult) );
            endnode = endnode(1);
            
            [rows,cols]=find(rawNodes & rawE(:,1:2)==endnode);
            
            % try
            %for e = 1:ec,
            e=0;
            while true,
                % next segment
                e=e+1;
                
                % get the first vertex
                r = rows(1);
                o = cols(1);
                v1 = rawE(r,o);
                
                % get the other vertex
                if o==1,
                    v2 = rawE(r,2);
                else
                    v2 = rawE(r,1);
                end
                
                % store it
                cE(e,1) = v1;
                cE(e,2) = v2;
                cE(e,3) = s; % curve index
                cE(e,4) = e; % local edge index
                cE(e,5) = rawE(r,3);
                
                fprintf(' %4d %4d %3d %4d %2d\n',cE(e,:));
                
                % this edge is used
                free(r,:) = 0;
                
                % which edges contain the vertex v2?
                edges = ismember(rawE(:,1:2),v2);
                
                % get the other edge containing this vertex
                [rows,cols] = find(edges & free);
                
                if isempty(rows),
                    disp('break inner while');
                    break; % inner while
                end
            end
%         catch
%                 error([...
%                     'problem ordering curve %d\n'...
%                     '  last edge: %d,%d\n'...
%                     '  r=%d\n'...
%                     ],c,v1,v2,r)
%         end

        end % outer while
        
        % store
        E(shift+(1:ec),:) = cE;
        shift = shift+ec;
        
        % plot
        if sum(cE(:,5)>0),
            op = plotoptions.bdcurves;
        else
            op = plotoptions.incurves;
        end
        
        % plot curve
        plotCurve3( V( [cE(:,1); cE(end,2)],:), op);
    end
    
    % trim
    E(shift+1:end,:) = [];
    
    %% Put the nodes in the beginning
    disp('Shifting node indices')
    n = length(nodes);
    
    hinodes = setdiff(nodes,1:n);
    lonodes  = setdiff(1:n,nodes);
    keys   = [hinodes lonodes];
    values = [lonodes hinodes];
       
    V(keys,:) = V(values,:);
    N(keys,:) = N(values,:);
    
    [which,idx] = ismember( E(:,1:2), keys );
    E(which) = values(idx(which));
    nodes = 1:n;
    
    disp('New nodes:')
    fprintf([repmat('%5d',1,5) '\n'],nodes);
    fprintf('\n');

    %% Export
    fprintf('%d curves\n',length(curves));
    
    bdcount = sum(E(:,5));
    incount = length(E) - bdcount;
    
    fprintf('%4d in edges\n',incount);
    fprintf('%4d bd edges\n',bdcount);

    outfile = strrep(filename,'.blendernet','.net');
    fprintf('Exporting %s...\n',outfile);
    
    options.nodes = nodes;
    writeNET(V,N,E,outfile,options);
    
%     fprintf(' %4d %4d %3d %4d %2d : %2d %2d : %2d %2d\n',[E which idx]');
    
    disp('done.');

end
