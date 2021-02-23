function rec = infection2_influence(data,N,R,f)
%Given the data of the temporal network 
%and the number of iterations we want to run
%Conduct the Susceptible-Infected process starting from one node

%Returns the process record rec in which records 
%the time instance that node i act as a seed node approaches the top f influential
%nodes.

frac = floor(N*f);
M = R(1:frac);

T = max(data(:,3));
rec = zeros(N,1);
really = 0;
for i = 1:N
    bad_node = [i]; % The log of infected nodes in each iteration
%     infected = length(bad_node); %Calculate how many nodes are infected
    c = 0;
    for t = 1:T      
        index = find(data(:,3) == t); %Extract the segment of the data corresponds to the current time stamp
        st = [data(index,1);data(index,2)];% The starting nodes, since we have an undirected graph, we would establish the matrix as [L+;L-] 
        st1 = unique(st); %The starting nodes at the time stamp t
        en = [data(index,2);data(index,1)]; %The ending nodes at time stamp t(both directions)
        ind = [];
        for s = 1:length(st1)
            ind0 = find(bad_node == st1(s)); %Find if the starting nodes contains any of the infected nodes
            if isempty(ind0) == 0 %Check there is any infected nodes sending out messages
                for in = 1:length(ind0)
                    ind = [ind (find(st == bad_node(ind0(in))))']; %Get the corresponding location
                end
            end     
        end
        bad = en(ind);
        bad_node = [bad_node bad'];
        bad_node = unique(bad_node);
        infected = length(bad_node);
        for p = 1:infected
            if isempty(find(M == bad_node(p), 1)) == 0
                rec(i) = t;
                really= 1;
                c =1;
                break
            end
        end
        if c == 1
            break
        end
    end
    
    if really == 0
        rec = T+1;
    end
end



end