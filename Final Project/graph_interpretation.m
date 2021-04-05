%% Duel
disp(' ')
disp(' ')
disp('Duel graph')
disp(' ')
graphhaha = duelgraph;
N = size(players,1);
L = find_link_num(graphhaha,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_D = var(Deg);
std = sqrt(Var_D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
disp(['The standard deviation of the degree is ', num2str(std)])
Rho_D = deg_assortivity(A,1);
[C_G,C_i] = clustering_coeff(A,1);
[avg_hopcount,network_diameter] = hopcount(A,1);
lambda1 = spectral_radius(A,1); 
miu_m2 = algebraic_connectivity(A,1);
[A_w,weights] = weighted_A_gen(graphhaha,N);
%%Plotting
figure
G = graph(A_w);
p = plot(G);
p.MarkerSize = 12;
p.LineWidth = weights(:,1);
p.XData = [ones(1,length(team1)), ones(1,length(team2))*10];
p.YData = [1:3:(length(team1)-1)*3+1,1:3:(length(team2)-1)*3+1];
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
title(['Duel Graph  ',data0(matchselect).label])

%% Passgraph
disp(' ')
disp(' ')
disp('Passing graph')
disp(' ')
graphhaha = passgraph(passgraph(:,4)==1,:);
N = size(players,1);
L = find_link_num(graphhaha,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_D = var(Deg);
std = sqrt(Var_D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
disp(['The standard deviation of the degree is ', num2str(std)])
Rho_D = deg_assortivity(A,1);
[C_G,C_i] = clustering_coeff(A,1);
[avg_hopcount,network_diameter] = hopcount(A,1);
lambda1 = spectral_radius(A,1); 
miu_m2 = algebraic_connectivity(A,1);
[A_w,weights] = weighted_A_gen(graphhaha,N);
%%Plotting
figure
img = imread('pitch.png');
theta = linspace(0,4*pi,200);
image('CData',img,'XData',[0 200],'YData',[0 100])
hold on 
G = graph(A_w);
p = plot(G,'NodeLabel',player_labels);
p.NodeFontWeight='bold';
p.MarkerSize = 12;
p.LineWidth = weights(:,1);
p.XData = [pos_team1(:,2)',200-(pos_team2(:,2)')];
p.YData = [pos_team1(:,3)',pos_team2(:,3)'];
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
title(['Passing Graph  ',data0(matchselect).label])
xlim([0,200])
ylim([0,100])
hold off

%% Loseballgraph
disp(' ')
disp(' ')
disp('Loseball graph')
disp(' ')
graphhaha = passgraph(passgraph(:,4)==0,:);
N = size(players,1);
L = find_link_num(graphhaha,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_D = var(Deg);
std = sqrt(Var_D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
disp(['The standard deviation of the degree is ', num2str(std)])
Rho_D = deg_assortivity(A,1);
[C_G,C_i] = clustering_coeff(A,1);
[avg_hopcount,network_diameter] = hopcount(A,1);
lambda1 = spectral_radius(A,1); 
miu_m2 = algebraic_connectivity(A,1);
[A_w,weights] = weighted_A_gen(graphhaha,N);
%%Plotting
figure
img = imread('pitch.png');
theta = linspace(0,4*pi,200);
image('CData',img,'XData',[0 200],'YData',[0 100])
hold on 
G = graph(A_w);
p = plot(G,'NodeLabel',player_labels);
p.NodeFontWeight='bold';
p.MarkerSize = 12;
plot_weights = weights(:,1);
% for i = 1:size(weights,1)
%     plot_weights(i) = max([0 weights(i,1)-loseball_filter]);
% end
p.LineWidth = plot_weights;
p.XData = [pos_team1(:,2)',200-pos_team2(:,2)'];
p.YData = [pos_team1(:,3)',pos_team2(:,3)'];
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
title(['Loseball Graph  ',data0(matchselect).label])
xlim([0,200])
ylim([0,100])
hold off