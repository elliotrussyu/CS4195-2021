function [A_weighted,link_weight_list] = weighted_A_gen(ds,N)
% This function generates a weighted adjacency matrix of the network
% based on the total contact numbers in the temporal network data
    ds_temp = ds(:,1:2);
    ds_new = sort(ds_temp,2);
    A_w = zeros(N);
    for i = 1:length(ds_new)
        x = ds_new(i,1);
        y = ds_new(i,2);
        A_w(x,y) = A_w(x,y) + 1;
    end
    A_weighted = A_w + A_w';
    link_weight_list =[];
    for i = 1:N
        for j = 1:N
            w0 = A_w(i,j);
            if w0 ~= 0
                link_weight_list = [link_weight_list; w0,i,j];
            end
        end
    end
    
end