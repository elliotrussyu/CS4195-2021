function pos = player_pos(data,players)


pos = zeros(length(players),2);
for i = 1:length(players)
    p = players(i);
    data_p = data([data.playerId]==p,:);
    x = 0;
    y = 0;
    for j = 1:size(data_p,1)
        it = data_p(j,:);
        y0 = [it.positions.y];
        y0 = y0(1)/size(data_p,1);
        x0 = [it.positions.x];
        x0 = x0(1)/size(data_p,1);
        x = x+x0;
        y = y+y0;
    end
    pos(i,:) = [x,y];
end
pos = [players,pos];
end