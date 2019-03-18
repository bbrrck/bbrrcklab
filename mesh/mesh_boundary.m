function v = MeshBoundary(F)
% BOUNDARY_VERTS
%   determine which vertices in the mesh F are on boundary

    f1 = F(:,1);
    f2 = F(:,2);
    f3 = F(:,3);

    E = [f1 f2; f2 f3; f3 f1];
    E = sort(E,2);
    
    [~,uI,I] = unique(E,'rows','first');
            
    count = zeros(length(uI),1);
    for i=1:length(I)
        count(I(i)) = count(I(i))+1;
    end
    
    bd = find(count==1)';
    
    v = E(uI(bd),:);
    v = reshape(v,1,[]);
    v = unique(v);
    
end