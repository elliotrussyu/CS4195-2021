function [A,nodes,Deg,links] = adjacency_matrix_gen(data,di)

if nargin == 1
    di = 0;
end

nodes = unique([data(:,1);data(:,2)]);
nodes = sort(nodes,'ascend');
links = unique(data(:,1:2),'rows');
start = links(:,1);
endn = links(:,2);
% [~,I] = sort(links(:,1),'ascend');
% 
% links_sorted = [start(I),endn(I)];
% begin = start(I);
% stop = endn(I);

A = zeros(length(nodes));
Deg = zeros(length(nodes),1);

for i = 1:length(nodes)
    indices = find(start == nodes(i));
    for k = 1:length(indices)
        A(i,endn(indices(k))) = 1;
        A(endn(indices(k)),i) = 1;
    end
    Deg(i) = length(find(A(i,:)));
end

if di == 1
    disp('The adjacency matix is as follows:')
    disp(A)
    disp('The node degrees are as follows:')
    disp(Deg)
end
end