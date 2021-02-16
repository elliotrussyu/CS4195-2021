function rec = infection(data,N)
T = max(data(:,3));
rec = zeros(N,T+1);
for i = 1:N

    bad_node = [i];
    infected = length(bad_node);
    rec(i,1) = infected;
    for t = 1:T        
        index = find(data(:,3) == t);
        st = data(index,1);
        st1 = unique(st);
        en = data(index,2);
        ind = [];
        for s = 1:length(st1)
            ind0 = find(bad_node == st1(s));
            if isempty(ind0) == 0
                for in = 1:length(ind0)
                    ind = [ind (find(st == bad_node(ind0(in))))'];
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