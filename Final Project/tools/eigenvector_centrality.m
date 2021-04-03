
function c = eigenvector_centrality(A)

%Given the adjacency matrix of a graph
%Find the eigenvector_centrality

[c, ~] = eigs(A, [], 1, 'LM');

end 


%[V,D] = eigs(sparse(A));
%[~,idx] = max(diag(D));
%ec = abs(V(:,idx));
%eigenvector_centrality = reshape(ec, length(ec), 1);
