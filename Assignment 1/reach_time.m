function R = reach_time(data,N)

    R = [];
    d = data(:,2);
    for i = 1:N
        n = find(d == i,1);
        R = [R;data(n,3)];
        
    end
        
end