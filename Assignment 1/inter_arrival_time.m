function tl = inter_arrival_time(links,data)
% This function takes the input data and finds the inter-arrival time 
% of each link in the temporal network.
ab = sort(data(:,1:2),2);
ts = data(:,3);
tl = [];
for i = 1:size(links,1)
    ind = ismember(ab,links(i,:),'rows');
    if length(find(ind)) > 1
        time = ts(ind);
        for k = 1:length(time)-1
            tl = [tl;time(k+1)-time(k)];
        end
    end
%     tl = [tl;length(find(ind))];
end


end