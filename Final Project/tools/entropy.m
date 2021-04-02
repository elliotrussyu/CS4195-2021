function E = entropy(Deg)

%Given the degree of each node
%Find the entropy

D=Deg/sum(Deg);
E = -sum(D .* log2(D));

end 
