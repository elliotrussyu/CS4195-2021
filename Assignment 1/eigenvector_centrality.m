function EC = eigenvector_centrality(A)
    EC = zeros(length(A),1);
    [V,D,~] = eig(A);
    [m,i] = max(max(D));
    v = V(:,i);
    for n = 1:length(A)
        h = A(:,n).*v;
        EC(n) = (1/m)*sum(h);
    end
end