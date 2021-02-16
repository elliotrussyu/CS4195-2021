function A_weighted = weighted_A_gen(ds,N)
% This function generates a weighted adjacency matrix of the network
% based on the total contact numbers in the temporal network data
    ds_temp = ds(:,1:2);
    ds_new = sort(ds_temp,2);
    A_weighted = zeros(N);
    for i = 1:height(ds_new)
        x = ds_new(i,1);
        y = ds_new(i,2);
        A_weighted(x,y) = A_weighted(x,y) + 1;
    end


end