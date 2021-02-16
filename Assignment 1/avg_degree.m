function E_D = avg_degree(N,L,di)

if nargin == 2
    di = 0;
end
E_D = (2*L)/N;

if di == 1
    disp(['The average degree E[D] is ',num2str(E_D)])
end

end