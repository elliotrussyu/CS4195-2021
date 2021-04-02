function E = entropy(A)

%Given the adjacency matrix of a graph
%Find the entropy

A(A==0) = [];
E = -sum(A .* log2(A));

end 
