function M = quat2rotm(q,options)
    M = zeros(3,3,size(q,1));
    w = q(:,1);
    x = q(:,2);
    y = q(:,3);
    z = q(:,4);
    if nargin < 2,
        options = struct;
    end
    if ~isfield(options,'method'),
        options.method = 'cols';
    end
    %disp(['quat2rotm : ' options.method ' conversion']);
    if strcmp(options.method,'rows'),
        % [Shoemake 85], corresponds to [T; N; B;] (in rows)
        % default
        M(1,1,:) = 2*(w.*w+x.*x)-1;
        M(2,2,:) = 2*(w.*w+y.*y)-1;
        M(3,3,:) = 2*(w.*w+z.*z)-1;
        
        M(1,2,:) = 2*(x.*y+w.*z);
        M(2,1,:) = 2*(x.*y-w.*z);
        M(1,3,:) = 2*(x.*z-w.*y);
        
        M(3,1,:) = 2*(x.*z+w.*y);
        M(2,3,:) = 2*(y.*z+w.*x);
        M(3,2,:) = 2*(y.*z-w.*x);
    elseif strcmp(options.method,'cols'),
        % Eigen:: version, corresponds to [T' N' B'] (in cols)
        M(1,1,:) = 1-2*(y.*y+z.*z);
        M(2,2,:) = 1-2*(x.*x+z.*z);
        M(3,3,:) = 1-2*(x.*x+y.*y);
        
        M(1,2,:) = 2*(x.*y-w.*z);
        M(2,1,:) = 2*(x.*y+w.*z);
        M(1,3,:) = 2*(x.*z+w.*y);
        
        M(3,1,:) = 2*(x.*z-w.*y);
        M(2,3,:) = 2*(y.*z-w.*x);
        M(3,2,:) = 2*(y.*z+w.*x);
    else
        error('Wrong conversion method.');
    end
end
