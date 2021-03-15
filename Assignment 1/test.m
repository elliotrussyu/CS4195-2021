abc1 = zeros(1,3250);
abc2 = zeros(1,3250);
abc3 = zeros(1,3250);
lin1 = sort(ds(:,1:2),2);
for i = 1:3250
    tf = ismember(lin1,links(i,:));
    abc1(i) = length(find(tf));
end
lin2 = sort(ds2(:,1:2),2);
for i = 1:3250
    tf = ismember(lin2,links(i,:));
    abc2(i) = length(find(tf));
end
lin3 = sort(ds3(:,1:2),2);
for i = 1:3250
    tf = ismember(lin3,links(i,:));
    abc3(i) = length(find(tf));
end
figure
subplot(3,1,1)
histogram(abc1)
title('Distribution of link appearance in G_{data}, G_2, and G_3')
ylabel('G_{data}')
subplot(3,1,2)
histogram(abc2)
ylabel('G_2')
subplot(3,1,3)
histogram(abc3)
ylabel('G_3')
