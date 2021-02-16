function p = link_density(N,L,di)
%Given the number of nodes, number of links,
%compute the link density of the graph
if nargin == 2
    di = 0;
end
tot_poss = N*(N-1)/2;
p = L/tot_poss;

if di == 1
    disp(['The link density is ',num2str(p)])
end