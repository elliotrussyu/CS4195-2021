tic
clear all
close all
clc

% ds = xlsread('manufacturing_emails_temporal_network.xlsx');
load('data.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%
% 1)
N = find_node_num(ds,1);
L = find_link_num(ds,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,D,links] = adjacency_matrix_gen(ds,0);
Var_D = var(D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2)
figure
histogram(D,max(D))
xlabel('Degrees');
ylabel('Number of nodes');
title('Degree distribution');
%%%%%%%%%%%%%%%%%%%%%%%%%
% 3)
Rho_D = deg_assortivity(A,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 4)
[C_G,C_i] = clustering_coeff(A,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 5)
[avg_hopcount,network_diameter] = hopcount(A,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 6)
link_p = L/((N*(N-1))/2);
A_ER_rand = ER_random_graph_gen(link_p,N);
ER_hc = hopcount(A_ER_rand);
C_ER = clustering_coeff(A_ER_rand);
disp('The small-world property determination:')
disp(['AVG_hopcount: OUR_NETWORK: ' num2str(avg_hopcount) ' ER_RAND_GRAPH: ' num2str(ER_hc)])
disp(['Clustering_COEFF: OUR_NETWORK: ' num2str(C_G) ' ER_RAND_GRAPH: ' num2str(C_ER)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% 7)
lambda1 = spectral_radius(A,1); 
%%%%%%%%%%%%%%%%%%%%%%%%%
% 8)
miu_m2 = algebraic_connectivity(A,1); 

%%%%%%%%%%%%%%%%%%%%%%%%%
% 9)
% rec = infection(ds,N);
load('rec_9.mat')
time = 0:1:57791;
std = sqrt(var(rec));
rec_p = mean(rec);
plot(time,rec_p);

toc