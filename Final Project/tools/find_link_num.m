function L = find_link_num(data,di)
%Given the data of the temporal network
%Find the number of links
if nargin == 1
    di = 0;
end

links = data(:,1:2);
S = size(unique(links,'rows'));
L = S(1);

if di == 1
    disp(['The number of links in this graph is ', num2str(L)])
end

end