function RHO_D = deg_assortivity(A,di)
%Given the adjacency matrix of a graph
%Find the assortivity(degree correlation)
    if nargin == 1
        di = 0;
    end
    D = sum(A);
    N1 = sum(D);
    N3 = sum(sum(A^3));
    N2 = D*D';
    D_cubic = sum(D.^3);
    RHO_D = (N1*N3-N2^2)/((N1*D_cubic)-N2^2);
    if di == 1
        disp(['The degree correlation (assortativity) is ',num2str(RHO_D)])
    end
end