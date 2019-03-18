function X = fit_bezier_network(curves,n,cnstr)
    
    b = @(k,t) nchoosek(n,k) .* (1-t).^(n-k) .* t.^k;
    c = length(curves);
    
    % block system
    Lhs = zeros(c*(n+1));
    Rhs = zeros(c*(n+1),2);
    
    % gather the matrices
    for k=1:c
        s=(k-1)*(n+1);
        P=curves(k).pts3;
        [t_unique,~,mask] = unique(curves(k).t);
        for i=0:n
            bi = b(i,t_unique);
            bi = bi(mask);
            for j=i:n
                bj = b(j,t_unique);
                bj = bj(mask);
                l = sum(bi.*bj);
                Lhs(s+i+1,s+j+1) = l;
                Lhs(s+j+1,s+i+1) = l;
            end
            Rhs(s+i+1,1) = sum(bi.*P(:,1));
            Rhs(s+i+1,2) = sum(bi.*P(:,2));
        end
    end
    

    % Lagrange multipliers
    % one C0 and one C1 per intersection
    C0 = zeros(size(cnstr,1),c*(n+1));
    for k=1:size(cnstr,1)
        
        i=cnstr(k,1);
        j=cnstr(k,2);
        
        is = (i-1)*(n+1);
        js = (j-1)*(n+1);
        
        %%% C0 %%%
        % first curve
        if cnstr(k,3)==0
            % first vertex
            C0(k,is+1) = +1;
        else
            % last vertex
            C0(k,is+(n+1)) = +1;
        end
        
        % second curve
        if cnstr(k,4)==0
            % first vertex
            C0(k,js+1) = -1;
        else
            % last vertex
            C0(k,js+(n+1)) = -1;
        end        
    end
    
%     C1 = [];
%     for k=1:size(cnstr,1)
%         
%         i=cnstr(k,1);
%         j=cnstr(k,2);
%         
%         is = (i-1)*(n+1);
%         js = (j-1)*(n+1);
%         
%         co = zeros(1,c*(n+1));
%         
%         %%% C1 %%%
%         if cnstr(k,3)==0 && cnstr(k,4)==0
%             % V2-V1
%             co(is+1) = -1;
%             co(is+2) = +1;
%             % W1-W2
%             co(js+1) = -1;
%             co(js+2) = +1;
%             
%             
%             C1 = [C1; co];
%            
% %         elseif cnstr(k,3)==0 && cnstr(k,4)==1
% %             % V2-V1
% %             co(is+2) = +1;
% %             co(is+1) = -1;
% %             % W4-W3
% %             co(js+(n+1)) = +1;
% %             co(js+(n+0)) = -1;
% %             
% %        elseif cnstr(k,3)==1 && cnstr(k,4)==0
% %             % V4-V3
% %             co(is+(n+1)) = +1;
% %             co(is+(n+0)) = -1;
% %             % W2-W1
% %             co(js+2) = +1;
% %             co(js+1) = -1;
% %             
% %        elseif cnstr(k,3)==1 && cnstr(k,4)==1
% %             % V4-V3
% %             co(is+(n+1)) = +1;
% %             co(is+(n+0)) = -1;
% %             % W3-W4
% %             co(js+(n+0)) = +1;
% %             co(js+(n+1)) = -1;
%             
% %         else
% %             error('bad constraints')
%             
%         end
%         
%     end
%     
%     C1
%     size(C1)

%     C = [C0; C1];
%     C = C0;
    C = [];

    q = size(C,1);
    
    A = [
        Lhs C'
        C zeros(q)
    ];
    B = [
        Rhs
        zeros(q,2)
        ];
   
    % solve
%     X = Lhs \ Rhs;
    
    
    % solve
    X = A \ B;
    X = X(1:c*(n+1),:);
    
end

