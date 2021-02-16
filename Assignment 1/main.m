% Feb. 16th 2021
% CS4195 Modeling and Data Analysis in Complex Networks
% Assignment 1
% Authors: 
%           Hanshu Yu 4907787,
%           Songlei Fang     ,
%           Ying Jin         .

tic
clear all
close all
clc

% ds = xlsread('manufacturing_emails_temporal_network.xlsx');

%Reading the data set from a xlsx file takes too much time
%thus a previous read variable called 'ds' is stored in file 'data.mat'
load('data.mat');
%% PART A
disp('PART A')
%%%%%%%%%%%%%%%%%%%%%%%%%
% 1)
disp('Q1:')
N = find_node_num(ds,1);
L = find_link_num(ds,1);
p = link_density(N,L,1);
E_D = avg_degree(N,L,1);
[A,nodes,D,links] = adjacency_matrix_gen(ds,0);
Var_D = var(D);
disp(['The degree variance Var[D] is ', num2str(Var_D)])
%%%%%%%%%%%%%%%%%%%%%%%%%
% 2)
% disp('Q2:')
figure
histogram(D,max(D))
xlabel('Degrees');
ylabel('Number of nodes');
title('Degree distribution');
%%%%%%%%%%%%%%%%%%%%%%%%%
% 3)
disp('Q3:')
Rho_D = deg_assortivity(A,1);
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
disp('Q8:')
[A_w,weights] = weighted_A_gen(ds,N);
figure
histogram(weights,100) %Perhaps find a better cell num for the histogram here!
xlabel('Link weights');
ylabel('Number of links');
title('Link weight distribution');
%% PART B
disp('PART B')
%%%%%%%%%%%%%%%%%%%%%%%%%
% 9)
disp('Q9:')
% rec9 = infection(ds,N); 
% The upper line takes around 15 min to run on a i7 cpu laptop
% The result is recorded in an array named 'rec9' in file 'rec_9.mat'
load('rec_9.mat')
time = 0:1:57791;
std = sqrt(var(rec9));
rec_p = mean(rec9);
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

%%%%%%%%%%%%%%%%%%%%%%%%
% 10)

toc