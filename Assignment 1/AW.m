

ds_temp = ds(:,1:2);
ds_new = sort(ds_temp,2);
ds_tt = ds(:,3);
A_w = zeros(N);
for i = 1:length(ds_new)
    x = ds_new(i,1);
    y = ds_new(i,2);
    A_w(x,y) = A_w(x,y) + 57792 - ds_tt(i);
end
A_weighted = A_w + A_w';
link_weight_list =[];
for i = 1:N
    for j = 1:N
        w0 = A_w(i,j);
        if w0 ~= 0
            link_weight_list = [link_weight_list; w0,i,j];
        end
    end
end

A_w = A_weighted;
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
DD = Deg./N;
SS = Str./max(Str);
DS = SS.*DD;
% ec2 = eigenvector_centrality(A_w);
[~,D] = sort(Deg,'descend');
[~,S] = sort(Str,'descend');
[~,Cl] = sort(C_i,'descend');
[~,L] = sort(l,'descend');
[~,EC] = sort(ec,'descend');
% [~,EC2] = sort(ec2,'descend');
[~,DDSS] =sort(DS,'descend');

fraction = 0.05:0.05:0.5;
rD = zeros(length(fraction),1);
rS = zeros(length(fraction),1);
rCl = zeros(length(fraction),1);
rL = zeros(length(fraction),1);
rEC = zeros(length(fraction),1);
rDDSS = zeros(length(fraction),1);
% rEC2 = zeros(length(fraction),1);
for f = fraction
    in = int16(f/0.05);
    rD(in) = top_f_recognition_rate(R,D,f);
    rS(in) = top_f_recognition_rate(R,S,f);
    rCl(in) = top_f_recognition_rate(R,Cl,f);
    rL(in) = top_f_recognition_rate(R,L,f);
    rEC(in) = top_f_recognition_rate(R,EC,f);
    rDDSS(in) = top_f_recognition_rate(R,DDSS,f);
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
    plot(fraction,rDDSS)
%     plot(fraction,rEC2)
    hold off
    legend('Strength','Degree','Clustering Coeff','closeness','Eigenvector Centrality','DS')%'Weighted Eig Centrality'
    xlabel('Fraction')
    ylabel('Top fraction recogintion rate')
end