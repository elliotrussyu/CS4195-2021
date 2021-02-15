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
G = graph(A);
d = distances(G);
avg_hopcount = mean(d);
network_diameter = max(d);
%%%%%%%%%%%%%%%%%%%%%%%%%
% 6)
%%%%%%%%%%%%%%%%%%%%%%%%%
% 7)
%%%%%%%%%%%%%%%%%%%%%%%%%
% 8)
toc
