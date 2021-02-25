function data2 = reshuffle_time_stamp(data)

    d0 = data(:,3);
    d0 = d0(randperm(size(d0, 1)), :);
    [d0,d2I] = sort(d0,'ascend');
    
    data2 = [data(d2I,1:2),d0];
end