N = size(players,1);
L = find_link_num(duelgraph,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,Deg,links] = adjacency_matrix_gen(duelgraph);
Var_D = var(Deg);
std = sqrt(Var_D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
disp(['The standard deviation of the degree is ', num2str(std)])
Rho_D = deg_assortivity(A,1);
[C_G,C_i] = clustering_coeff(A,1);
[avg_hopcount,network_diameter] = hopcount(A,1);
lambda1 = spectral_radius(A,1); 
miu_m2 = algebraic_connectivity(A,1);
[A_w,weights] = weighted_A_gen(duelgraph,N);
%% Plotting
G = graph(A_w);
p = plot(G);
p.MarkerSize = 7;
p.LineWidth = weights(:,3)/10;
p.XData = [ones(1,14), ones(1,14)*10];
p.YData = [1:3:13*3+1,1:3:13*3+1];
colorsetting = [];
for i = 1:N
    if i <= playernum(1)
        colorsetting = [colorsetting;[1 0 0]];
    else
        colorsetting = [colorsetting;[1 0 1]];
    end
end
p.NodeColor = colorsetting;
p.LineStyle = '-';