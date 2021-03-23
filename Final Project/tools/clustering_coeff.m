function [C_G,C_i] = clustering_coeff(A,di)
%Given the adjacency matrix of a graph
%Find the clustering coefficient C_G of the graph 
%Also store the clustering coefficient of each node in C_i
    if nargin == 1
        di = 0;
    end
    D = sum(A);
    C_i = zeros(1,length(A));
    
    for i  = 1:length(D)
%         A_new = [];
        n = find(A(i,:));
        if D(i) == 1 || D(i) == 0
            C_i(i) = 0;
        else
           d = (D(i)*(D(i)-1))/2;
           A1 = A(n,n);
           lk = sum(sum(A1))/2;
           C_i(i) = lk/d;
        end
    end
    C_G = sum(C_i)/length(D);
    if di == 1
        disp(['The clustering coefficient of the graph is ', num2str(C_G)])
    end
end