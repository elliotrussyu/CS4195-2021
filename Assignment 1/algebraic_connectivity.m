function miu_N_1 = algebraic_connectivity(A,di)
%Given the adjacency matrix of a graph
%Find the algebraic connectivity
    if nargin == 1
        di = 0;
    end
    
    D = sum(A);
    delta = diag(D);
    Q = delta - A;
    miu_all = eig(Q);
    miu_s = sort(miu_all);
    miu_N_1 = miu_s(2);
    
    if di == 1
        disp(['The algebraic connectivity miu_(N-1) is ' num2str(miu_N_1)])
    end
end