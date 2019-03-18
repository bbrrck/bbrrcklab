function [ curves, count, gnodes, xlimits ] = ...
    readRAWNET( options )

if nargin==0, options = struct; end

if ~isfield(options,'filename'), options.filename = 'export.rawnet'; end
if ~isfield(options,'verbose'),  options.verbose  = 1; end
if ~isfield(options,'datapath'), options.datapath = 'data/'; end
if ~isfield(options,'curvepath'),options.curvepath= options.datapath; end

if options.verbose==1,
    %separatorBig();
    fprintf('Read %s%s\n',options.datapath,options.filename);
end

% open for reading
netfile = fopen( [options.datapath options.filename], 'r' );
% init data
curves = struct('bd',[],'closed',[],'gnodes',[],'raw',[]);
xlimits = [-Inf Inf];
% get mode / number of curves
line = fgetl( netfile );
parts = strsplit(line,'#');
mode = str2num(parts{1});

% There are two possibilities for the file structure.
% if mode==0, curves are stored in separate files.
% else, mode expresses the curvecount.
if mode == 0,
    line = fgetl( netfile );
    parts = strsplit(line,'#');
    count = str2num(parts{1});
else
    count = mode;
end

if options.verbose==1, fprintf('%i curves\n',count); end

% init line numbering for debugging
lineNo = 0;
% init list of global nodes
gnodes = [];
% read each curve

% try
    for c = 1:count,

        if mode == 0,
            % mode = 0 : curves specified in multiple curvefiles

            %
            % Get the next line.
            % IMPORTANT NOTE:
            % One line corresponds to a single smooth curve.
            % However, the line might contain multiple filenames,
            % separated by spaces.
            % These are the segments of the curve, joint together C1 smoothly.
            % Each segment is read separately and appended to the same curve
            % stored in curves(c).
            %
            curvefiles = strsplit(fgetl( netfile ),' ')';

            % loop over curve segments
            for i=1:length( curvefiles ),
                filename = curvefiles{i};

                % display curve filename
                if options.verbose==1, disp( filename ); end

                % get the file
                [ path, name, ext ] = fileparts(filename);
                if strcmp(ext,'.reversed'),
                    % Reverse the segment.
                    % For instance, if we specify the file
                    %
                    %      lilium/lilium_i_8-3.reversed
                    %
                    % we'll actually read
                    %
                    %      lilium/lilium_i_8-3.rawcurve
                    %
                    % and store the result in reversed order: 3-8
                    %
                    filename = [path '/' name '.rawcurve'];
                    reversed = true;
                else
                    % Normal mode.
                    reversed = false;
                end

                % read the segment
                clear segment;
                segmentfile = fopen( [options.curvepath filename], 'r' );
                lineNo = 0;
                [ segment, lineNo ] = readCurve( segmentfile, lineNo );
                fclose( segmentfile );

                % reverse if needed
                if reversed,
                    if options.verbose==1, disp('reversing...'); end
                    segpts = length(segment.raw.D);
                    segment.gnodes = fliplr(segment.gnodes);
                    segment.raw.lnodes = fliplr(segpts-segment.raw.lnodes+1);
                    segment.raw.D = segment.raw.D(end)-flipud( segment.raw.D );
                    % tangents must be reversed too
                    segment.raw.T = -flipud( segment.raw.T );
                    % normals are kept with original orientation
                    segment.raw.N = +flipud( segment.raw.N );
                end
                if i==1,
                    % the first segment
                    curve = segment;
                else
                    % next segments
                    % trim the first node
                    segment.gnodes(1) = [];
                    segment.raw.lnodes(1) = [];
                    segment.raw.D(1) = [];
                    segment.raw.T(1,:) = [];
                    segment.raw.N(1,:) = [];
                    % shift
                    shift = length( curve.raw.D )-1;
                    clength = curve.raw.D(end);
                    % store
                    curve.gnodes = [ curve.gnodes, segment.gnodes ];
                    curve.raw.lnodes = ...
                        [ curve.raw.lnodes, segment.raw.lnodes + shift ];
                    curve.raw.D = [ curve.raw.D; segment.raw.D + clength ];
                    curve.raw.T = [ curve.raw.T; segment.raw.T ];
                    curve.raw.N = [ curve.raw.N; segment.raw.N ];
                end
            end

        else
            % mode ~= 0 : all curves specified in the same netfile
            [curve,lineNo] = readCurve(netfile,lineNo);
        end

        % store the curve
        curves(c) = curve;
        % store the global nodes
        gnodes( end + (1:length(curve.gnodes)) ) = curve.gnodes;
    end

% catch
%     % if problems, specify location and throw error.
%     disp('Error')
%     disp('-----')
%     disp(['curve=' num2str(c)]);
%     disp(['lineNo=' num2str(lineNo)]);
%     disp(['line=' line]);
%     error('Problem reading network.');
% end

% get unique gnodes
gnodes = unique(gnodes);

% reading done, close
fclose( netfile );

if options.verbose==1,
    disp('Success.');
    fprintf('nodes=[ ');
    fprintf('%d ',unique(gnodes));
    fprintf(']\n');
end

% --------------------------------------------------
% Helper function : readCurve
% --------------------------------------------------
    function [curve,lineNo] = readCurve(file,lineNo)
        
        % 1. is boundary?
        line = fgetl(file); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        bd = str2num(parts{1});

        % 2. is closed?
        line = fgetl( file ); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        cl = str2num(parts{1});

        % 3. number of nodes
        line = fgetl( file ); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        nodecount = str2num(parts{1});

        % 4. node indices, local
        line = fgetl( file ); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        ln = str2num(parts{1});

        % 5. node indices, global
        line = fgetl( file ); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        gn = str2num(parts{1});

        % 6. number of samples
        line = fgetl( file ); lineNo=lineNo+1;
        parts = strsplit(line,'#');
        p = str2num(parts{1});
        
        if nodecount < 2,
            ln = [1 p];
            gn = [1 1];
        end
        
        dim=7;

        % 7. distance (1d), tangents (3d), normals (3d)
        DTN = reshape(fscanf(file,'%f',dim*p),dim,[])';
        fgetl( file );  lineNo=lineNo+p;

        % trim start- and end-data
        n0 = ln(1);
        n1 = ln(end);
        idx = n0 : n1;

        % store
        curve = struct;
        curve.bd         = bd;
        curve.closed     = cl;
        curve.gnodes     = gn;
        curve.raw.lnodes = ln - n0 + 1;
        curve.raw.D      = DTN(idx,1);
        curve.raw.T      = DTN(idx,2:4);
        curve.raw.N      = DTN(idx,5:7);

        % modify the distance to start at 0
        curve.raw.D = curve.raw.D - curve.raw.D(1);

    end % function readcurve()

end % function readRAWNET()
