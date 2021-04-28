%% Duel
if displayflag==1
    disp(' ')
    disp(' ')
    disp('Duel graph')
    disp(' ')
end
graphhaha = duelgraph;
Nd = size(players,1);
Ld = find_link_num(graphhaha,displayflag);
pd = link_density(Nd,Ld,displayflag);
E_Dd = avg_degree(Nd,Ld,displayflag);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_Dd = var(Deg);
stdd = sqrt(Var_Dd);
if displayflag == 1
    disp(['The degree variance Var[D] is ', num2str(Var_Dd)])
    disp(['The standard deviation of the degree is ', num2str(stdd)])
end
Rho_Dd = deg_assortivity(A,displayflag);
[C_Gd,C_id] = clustering_coeff(A,displayflag);
[avg_hopcountd,network_diameterd] = hopcount(A,displayflag);
lambda1d = spectral_radius(A,displayflag); 
miu_m2d = algebraic_connectivity(A,displayflag);
[A_w,weights] = weighted_A_gen(graphhaha,Nd);
Sd = strength(A_w);
E_Sd = sum(Sd)/Nd;
%%Plotting
if plotflag == 1
    figure
    G = graph(A_w);
    p = plot(G);
    p.MarkerSize = 12;
    p.LineWidth = weights(:,1);
    p.XData = [ones(1,length(team1)), ones(1,length(team2))*10];
    p.YData = [1:3:(length(team1)-1)*3+1,1:3:(length(team2)-1)*3+1];
    colorsetting = [];
    for i = 1:Nd
        if i <= playernum(1)
            colorsetting = [colorsetting;[1 0 0]];
        else
            colorsetting = [colorsetting;[1 0 1]];
        end
    end
    p.NodeColor = colorsetting;
    p.LineStyle = '-';
    title(['Duel Graph  ',data0(matchselect).label])
end
%% Passgraph
if displayflag == 1
    disp(' ')
    disp(' ')
    disp('Passing graph')
    disp(' ')
end
passgraph0 = passgraph(passgraph(:,4)==1,:);
t1p = passgraph0(passgraph0(:,1)<= length(team1),:);
t2p = passgraph0(passgraph0(:,1)> length(team1),:);


graphhaha = passgraph(passgraph(:,4)==1,:);
Np = size(players,1);
Lp = find_link_num(graphhaha,displayflag);
pp = link_density(Np,Lp,displayflag);
E_Dp = avg_degree(Np,Lp,displayflag);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_Dp = var(Deg);
stdp = sqrt(Var_Dp);
if displayflag == 1
    disp(['The degree variance Var[D] is ', num2str(Var_Dp)])
    disp(['The standard deviation of the degree is ', num2str(stdp)])
end
Rho_Dp = deg_assortivity(A,displayflag);
[C_Gp,C_ip] = clustering_coeff(A,displayflag);
[avg_hopcountp,network_diameterp] = hopcount(A,displayflag);
lambda1p = spectral_radius(A,displayflag); 
miu_m2p = algebraic_connectivity(A,displayflag);
[A_w,weights] = weighted_A_gen(graphhaha,Np);
Sp = strength(A_w);
E_Sp = sum(Sp)/Np;
%%Plotting
if plotflag == 1

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
    for i = 1:Np
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
end

%Team1
graphhaha = t1p;
Np1 = playernum(1);
Lp1 = find_link_num(graphhaha,displayflag);
pp1 = link_density(Np1,Lp1,displayflag);
E_Dp1 = avg_degree(Np1,Lp1,displayflag);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_Dp1 = var(Deg);
stdp1 = sqrt(Var_Dp1);
if displayflag == 1
    disp(['The degree variance Var[D] is ', num2str(Var_Dp1)])
    disp(['The standard deviation of the degree is ', num2str(stdp1)])
end
Rho_Dp1 = deg_assortivity(A,displayflag);
[C_Gp1,C_ip1] = clustering_coeff(A,displayflag);
[avg_hopcountp1,network_diameterp1] = hopcount(A,displayflag);
lambda1p1 = spectral_radius(A,displayflag); 
miu_m2p1 = algebraic_connectivity(A,displayflag);
[A_w,weights] = weighted_A_gen(graphhaha,Np1);
Sp1 = strength(A_w);
E_Sp1 = sum(Sp1)/Np1;
%%Plotting
if plotflag == 1

    figure
    img = imread('pitch.png');
    theta = linspace(0,4*pi,100);
    image('CData',img,'XData',[0 100],'YData',[0 100])
    hold on 
    G = graph(A_w);
    p = plot(G,'NodeLabel',player_labels(1:playernum(1)));
    p.NodeFontWeight='bold';
    p.MarkerSize = 25;
    p.LineWidth = weights(:,1);
    p.XData = [pos_team1(:,2)'];
    p.YData = [pos_team1(:,3)'];
    colorsetting = [];
    for i = 1:Np1
        if i <= playernum(1)
            colorsetting = [colorsetting;[1 0 0]];
        else
            colorsetting = [colorsetting;[1 0 1]];
        end
    end
    p.NodeColor = colorsetting;
    p.LineStyle = '-';
    title(['Passing Graph  ',data0(matchselect).label])
    xlim([0,100])
    ylim([0,100])
    hold off
end
%Team2
graphhaha = t2p;
Np2 = playernum(2);
Lp2 = find_link_num(graphhaha,displayflag);
pp2 = link_density(Np2,Lp2,displayflag);
E_Dp2 = avg_degree(Np2,Lp2,displayflag);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_Dp2 = var(Deg);
stdp2 = sqrt(Var_Dp2);
if displayflag == 1
    disp(['The degree variance Var[D] is ', num2str(Var_Dp2)])
    disp(['The standard deviation of the degree is ', num2str(stdp2)])
end
Rho_Dp2 = deg_assortivity(A,displayflag);
[C_Gp2,C_ip2] = clustering_coeff(A,displayflag);
[avg_hopcountp2,network_diameterp2] = hopcount(A,displayflag);
lambda1p2 = spectral_radius(A,displayflag); 
miu_m2p2 = algebraic_connectivity(A,displayflag);
[A_w,weights] = weighted_A_gen(graphhaha,sum(playernum));
A_w = A_w(playernum(1)+1:end,playernum(1)+1:end);
weights = weights(weights(:,2) > playernum(1),:);
Sp2 = strength(A_w);
E_Sp2 = sum(Sp2)/Np2;
%%Plotting
if plotflag == 1

    figure
    img = imread('pitch.png');
    theta = linspace(0,4*pi,100);
    image('CData',img,'XData',[0 100],'YData',[0 100])
    hold on 
    G = graph(A_w);
    p = plot(G,'NodeLabel',player_labels(playernum(1)+1:end));
    p.NodeFontWeight='bold';
    p.MarkerSize = 12;
    p.LineWidth = weights(:,1);
    p.XData = [100-(pos_team2(:,2)')];
    p.YData = [pos_team2(:,3)'];
    colorsetting = [];
    for i = 1:Np2
        if i <= playernum(1)
            colorsetting = [colorsetting;[0 1 1]];
        else
            colorsetting = [colorsetting;[1 0 1]];
        end
    end
    p.NodeColor = colorsetting;
    p.LineStyle = '-';
    title(['Passing Graph  ',data0(matchselect).label])
    xlim([0,100])
    ylim([0,100])
    hold off
end
%% Loseballgraph
if displayflag == 1
    disp(' ')
    disp(' ')
    disp('Loseball graph')
    disp(' ')
end
graphhaha = passgraph(passgraph(:,4)==0,:);
Nl = size(players,1);
Ll = find_link_num(graphhaha,displayflag);
pl = link_density(Nl,Ll,displayflag);
E_Dl = avg_degree(Nl,Ll,displayflag);
[A,nodes,Deg,links] = adjacency_matrix_gen(graphhaha);
Var_Dl = var(Deg);
stdl = sqrt(Var_Dl);
if displayflag == 1 
    disp(['The degree variance Var[D] is ', num2str(Var_Dl)])
    disp(['The standard deviation of the degree is ', num2str(stdl)])
end
Rho_Dl = deg_assortivity(A,displayflag);
[C_Gl,C_il] = clustering_coeff(A,displayflag);
[avg_hopcountl,network_diameterl] = hopcount(A,displayflag);
lambda1l = spectral_radius(A,displayflag); 
miu_m2l = algebraic_connectivity(A,displayflag);
[A_w,weights] = weighted_A_gen(graphhaha,Nl);
Sl = strength(A_w);
E_Sl = sum(Sl)/Nl;
%%Plotting
if plotflag == 1
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
    for i = 1:Nl
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
end