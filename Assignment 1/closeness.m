function l = closeness(A)
    N = length(A);
    G = graph(A);
    d_m = distances(G);
    d = sum(d_m);
    l = N./d;

end