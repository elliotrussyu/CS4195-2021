function l = closeness(A)
    N = length(A);
    G = graph(A);
    d_m = distances(G); % shortest path of the graph
    d = sum(d_m); % return a row vector containing the sum of all hopcout between a node and the rest
    % d/N = average distance, the reciprocal is the closeness, 
    % the smaller, the closer a node is to the other nodes
    l = N./d; % the closeness of each node
end