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
plot_flag = 0;

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
    histogram(weights(:,1),50) %Perhaps find a better cell num for the histogram here!
%     set(gca,'XScale','log')
    set(gca,'YScale','log')
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
l = closeness(A);
ec = eigenvector_centrality(A);
% ec2 = eigenvector_centrality(A_w);
[~,D] = sort(Deg,'descend');
[~,S] = sort(Str,'descend');
[~,Cl] = sort(C_i,'descend');
[~,L] = sort(l,'descend');
[~,EC] = sort(ec,'descend');
% [~,EC2] = sort(ec2,'descend');


fraction = 0.05:0.05:0.5;
rD = zeros(length(fraction),1);
rS = zeros(length(fraction),1);
rCl = zeros(length(fraction),1);
rL = zeros(length(fraction),1);
rEC = zeros(length(fraction),1);
% rEC2 = zeros(length(fraction),1);
for f = fraction
    in = int16(f/0.05);
    rD(in) = top_f_recognition_rate(R,D,f);
    rS(in) = top_f_recognition_rate(R,S,f);
    rCl(in) = top_f_recognition_rate(R,Cl,f);
    rL(in) = top_f_recognition_rate(R,L,f);
    rEC(in) = top_f_recognition_rate(R,EC,f);
%     rEC2(in) = top_f_recognition_rate(R,EC2,f);
end

if plot_flag == 1
    figure
    hold on
    plot(fraction,rS)
    plot(fraction,rD)
    plot(fraction,rCl)
    plot(fraction,rL)
    plot(fraction,rEC)
%     plot(fraction,rEC2)
    hold off
    legend('Strength','Degree','Clustering Coeff','closeness','Eigenvector Centrality')%'Weighted Eig Centrality'
    xlabel('Fraction')
    ylabel('Top fraction recogintion rate')
end
%%%%%%%%%%%%%%%%%%%%%%%%
% 12)
% disp('Q12:') See above in Q11
%%%%%%%%%%%%%%%%%%%%%%%%
% 13)
% disp('Q13:')
rt = reach_time(ds,N);
rt = [99999;rt];
[~,r_t] = sort(rt,'ascend');
% rec_T = infection2_influence(ds,N,r_t,0.8); %Takes around 1 min to run
load('rec_T.mat')
[~,RT] = sort(rec_T,'ascend');
% !!!!!!!!!!!!!!!!!
% R'(RT) and R are eactly the same. 
% We found that node 1 is never sending only receiving. 
% But this has no effect on the ranking of R'.
% Further exploring the dataset, we find at time stamp 1720,
% there are 135 links operating in the network. Before that there were 122
% nodes appeared, and at 1720s, 13 new nodes appeared, which made it over
% 80% of the total node num.
%
% dbefore = unique(ds(1:find(ds(:,3)==1720)-1,2));
% d1720 = unique(ds(ds(:,3) == 1720,2));
% dnew1720 = [];
% for i = 1:length(d1720)
%     if isempty(find(dbefore == d1720(i))) == 1
%         dnew1720 = [dnew1720;d1720(i)];
%     end
% end
% length(dnew1720)
% !!!!!!!!!!!!!!!!!

%
% fraction = 0.05:0.05:0.5;
% rD = zeros(length(fraction),1);
% rS = zeros(length(fraction),1);
% rCl = zeros(length(fraction),1);
% rL = zeros(length(fraction),1);
% rEC = zeros(length(fraction),1);
% % rEC2 = zeros(length(fraction),1);
% for f = fraction
%     in = int16(f/0.05);
%     rD(in) = top_f_recognition_rate(RT,D,f);
%     rS(in) = top_f_recognition_rate(RT,S,f);
%     rCl(in) = top_f_recognition_rate(RT,Cl,f);
%     rL(in) = top_f_recognition_rate(RT,L,f);
%     rEC(in) = top_f_recognition_rate(RT,EC,f);
% %     rEC2(in) = top_f_recognition_rate(RT,EC2,f);
% end
% 
% if plot_flag == 1
%     figure
%     hold on
%     plot(fraction,rS)
%     plot(fraction,rD)
%     plot(fraction,rCl)
%     plot(fraction,rL)
%     plot(fraction,rEC)
% %     plot(fraction,rEC2)
%     hold off
%     legend('Strength','Degree','Clustering Coeff','closeness','Eigenvector Centrality')%'Weighted Eig Centrality'
%     xlabel('Fraction')
%     ylabel('Top fraction recogintion rate')
% end


%% PART C
disp('PART C')
%%%%%%%%%%%%%%%%%%%%%%%%
% 14)
% disp('Q14:')
ds2 = reshuffle_time_stamp(ds);
ds3 = re_assign_links_to_time_stamp(links,ds(:,3));









toc