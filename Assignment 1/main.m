% Feb. 16th 2021
% CS4195 Modeling and Data Analysis in Complex Networks
% Assignment 1
% Authors: 
%           Hanshu Yu 4907787,
%           Songlei Fang     ,
%           Ying Jin         .

% Please use the latest version of MATLAB, using an older version could
% result in some unexpected errors.

tic
clear all
close all
clc

% ds = xlsread('manufacturing_emails_temporal_network.xlsx');
%Reading the data set from a xlsx file takes too much time
%thus a previous read variable called 'ds' is stored in file 'data.mat'
load('data.mat');

%Since generating plots in matlab is rather slow on outdated computers,
%in convenience of the code users I introduce a flag
%'plot_flag' when set to 1 we do the plotting. 
%When set to zero we skip the plotting process
plot_flag = 1;

%% PART A
disp('PART A')
%%%%%%%%%%%%%%%%%%%%%%%%%
% 1)
disp('Q1:')
N = find_node_num(ds,1);
L = find_link_num(ds,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,Deg,links] = adjacency_matrix_gen(ds);
Var_D = var(Deg);
std = sqrt(Var_D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
disp(['The standard deviation of the degree is ', num2str(std)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2)
% disp('Q2:')
if plot_flag == 1
    figure
    histogram(Deg,max(Deg))
    xlabel('Degrees');
    ylabel('Number of nodes');
    title('Degree distribution');
end
%%%%%%%%%%%%%%%%%%%%%%%%%
% 3)
disp('Q3:')
Rho_D = deg_assortivity(A,1);
% preference for a network's node to attach to others that have similar degree
%%%%%%%%%%%%%%%%%%%%%%%%%
% 4)
disp('Q4:')
[C_G,C_i] = clustering_coeff(A,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 5)
disp('Q5:')
[avg_hopcount,network_diameter] = hopcount(A,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 6)
disp('Q6:')
link_p = L/((N*(N-1))/2);
A_ER_rand = ER_random_graph_gen(link_p,N);
ER_hc = hopcount(A_ER_rand);
C_ER = clustering_coeff(A_ER_rand);
disp('The small-world property determination:')
disp(['AVG_hopcount: OUR_NETWORK: ' num2str(avg_hopcount) ' ER_RAND_GRAPH: ' num2str(ER_hc)])
disp(['Clustering_COEFF: OUR_NETWORK: ' num2str(C_G) ' ER_RAND_GRAPH: ' num2str(C_ER)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% 7)
disp('Q7:')
lambda1 = spectral_radius(A,1); 
miu_m2 = algebraic_connectivity(A,1); 
%%%%%%%%%%%%%%%%%%%%%%%%%
% 8)
% disp('Q8:')
[A_w,weights] = weighted_A_gen(ds,N);
if plot_flag == 1
    figure
    histogram(weights,100) %Perhaps find a better cell num for the histogram here!
    xlabel('Link weights');
    ylabel('Number of links');
    title('Link weight distribution');
end

%% PART B
disp('PART B')
%%%%%%%%%%%%%%%%%%%%%%%%%
% 9)
% disp('Q9:')
% rec9 = infection(ds,N); 
% The upper line takes around 15 min to run on a i7 cpu laptop
% The result is recorded in an array named 'rec9' in file 'rec_9.mat'
load('rec_9.mat')
time = 0:1:57791;
std = sqrt(var(rec9));
rec_p = mean(rec9);
if plot_flag == 1
    figure
    errorbar(time,rec_p,std)
    title('The average number of infected nodes E[I(t)] (with errorbar)')
    xlabel('Time (s)')
    ylabel('Number of infected nodes')
    % This errorbar graph looks terrible!
    figure
    subplot(2,1,1)
    plot(time,rec_p)
    title('The average number of infected nodes E[I(t)] (without errorbar)')
    xlabel('Time (s)')
    ylabel('Number of infected nodes')
    subplot(2,1,2)
    plot(time,std)
    title('The standard deviation plot')
    xlabel('Time (s)')
    ylabel('Standard deviation')
end
%%%%%%%%%%%%%%%%%%%%%%%%
% 10)
% disp('Q10:')
threshold = 0.8;
influence_ranking = seed_node_influence_rank(rec9,N,threshold);
R = influence_ranking(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%
% 11)
% disp('Q11:')
Str = strength(A_w);
[~,D] = sort(Deg,'descend');
[~,S] = sort(Str,'descend');

fraction = 0.05:0.05:0.5;
rD = zeros(length(fraction),1);
rS = zeros(length(fraction),1);
for f = fraction
    in = int16(f/0.05);
    rD(in) = top_f_recognition_rate(R,D,f);
    rS(in) = top_f_recognition_rate(R,S,f);
end

if plot_flag == 1
    figure
    hold on
    plot(fraction,rS)
    plot(fraction,rD)
    hold off
    legend('r_S','r_D')
end
%%%%%%%%%%%%%%%%%%%%%%%%
% 12)
% disp('Q12:')

toc