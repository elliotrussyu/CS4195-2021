function E = entropy(D)

%Given the degree of each node
%Find the entropy

D1=D/sum(D);
E1 = -sum(D1 .* log2(D1));

end 
