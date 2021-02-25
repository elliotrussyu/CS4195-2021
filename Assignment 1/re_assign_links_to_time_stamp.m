function data2 = re_assign_links_to_time_stamp(links,timestamp)
    ind = randi([1 size(links,1)],size(timestamp,1),1);
    data2 = [links(ind,:),timestamp];


end