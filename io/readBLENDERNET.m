function [V,N,curves] = ...
    readBLENDERNET( filename )
% [positions,normals,network] = ReadNetworkFile( object_name )
% Read curve network information from a .network file
% located in the works/mesh/curve folder.
%
% input <
% -------
%   object_name - string, e.g. 'lilium'
%
% outputs <
% ---------
%   - positions
%   - normals
%   - network
%
% (c) 2015-2017 Tibor Stanko [ts@tiborstanko.sk]
%
    %% open file and read data
    f = fopen(filename,'r');
    rmode = '';
    % get first line
    tline = fgetl(f);
    curves = struct;
    ccount = 0;
    linenum = 0;
    % while not EOF == -1
    while ischar(tline),
        % determine the type of line by the first character
        linenum = linenum+1;
        first = tline(1);
        switch first,
            case 'v',
                rmode = first;
                count = str2num( tline(2:end) );
                v = count;
                vi = 0;
                V = zeros(v,3);
                N = zeros(v,3);
            case 'e',
                rmode = first;
                ccount = ccount+1;
                ecount = str2num( tline(2:end) );
                ei=0;
                curves(ccount).rawE = zeros(ecount,3);
            otherwise
                switch rmode
                    case 'v',
                        vi = vi + 1;
                        vdata = str2num( tline );
                        V(vi,:) = vdata(1:3);
                        N(vi,:) = vdata(4:6);
                    case 'e',
                        ei = ei+1;
                        parts = strsplit(tline);
                        parts(strcmp('',parts)) = [];
                        curves(ccount).rawE(ei,1:2) = 1+[str2double(parts(2)) str2double(parts(3))];
                        %  1  if  etag=='b'
                        %  0  if  etag=='i'
                        curves(ccount).rawE(ei,3) = strcmp(parts(1),'b');
                    otherwise,
                        error('invalid reading mode %i',rmode);
                end
        end
        % get next line
        tline = fgetl(f);
    end
    fprintf('%i vertices, %i curves\n',count,ccount)
    fclose(f);  
end