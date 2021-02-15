function A = ER_random_graph_gen(link_p,N)
    bits = N*(N+1)/2;
    rand_seq = rand(bits,1);
    
    for i = 1:bits
        if rand_seq(i) <= link_p
            rand_seq(i) = 1;
        else
            rand_seq(i) = 0;
        end
    end

    A = zeros(N);
    
    for k = 1:N
        A(k,k+1:end) = rand_seq(1:(N-k));
        rand_seq(1:(N-k)) = [];
    end
    A = A + A';
end