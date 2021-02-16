function N = find_node_num(data,di)
% Given the data of the temporal network
% Find the number of nodes in the network
if nargin == 1
    di = 0;
end

dat = [data(:,1);data(:,2)];
N = length(unique(dat));

if di == 1
    disp(['The number of nodes in this graph is ', num2str(N)])
end

end