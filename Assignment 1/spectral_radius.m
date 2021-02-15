function l1 = spectral_radius(A,di)
    if nargin == 1
        di = 0;
    end
    
    E = eig(A);
    l1 = max(E);
    
    if di == 1
        disp(['The largest eigenvalue lambda_1 of the adjacency matrix is ' num2str(l1)])
    end
end