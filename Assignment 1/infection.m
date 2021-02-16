function rec = infection(data,N)
%Given the data of the temporal network 
%and the number of iterations we want to run
%Conduct the Susceptible-Infected process starting from one node
%Returns the process record in which records 
%the number of infected nodes at each time stamp
T = max(data(:,3));
rec = zeros(N,T+1);
for i = 1:N

    bad_node = [i]; % The log of infected nodes in each iteration
    infected = length(bad_node); %Calculate how many nodes are infected
    rec(i,1) = infected;
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
        
        if infected == N
            rec(i,t+1:end) = infected;
            break;
        else
            rec(i,t+1) = infected;
        end
    end
end



% end