figure
hold on
for i = 1:7
    plot(alles(:,1+(i-1)*3),'o')
end
hold off
legend('England','Euro','France','Germany','Italy','Spain','World Cup')
title('Pass metrics correlation with wins per game')

figure
hold on
for i = 1:7
    plot(alles(:,2+(i-1)*3),'o')
end
hold off
legend('England','Euro','France','Germany','Italy','Spain','World Cup')
title('Pass metrics correlation with goals per game')

figure
hold on
for i = 1:7
    plot(alles(:,3+(i-1)*3),'o')
end
hold off
legend('England','Euro','France','Germany','Italy','Spain','World Cup')
title('Pass metrics correlation with lose goals per game')

figure
hold on
for i = 1:7
    plot(allest([2:6,10,11],1+(i-1)*2),'o')
end
hold off
legend('England','Euro','France','Germany','Italy','Spain','World Cup')
title('Duel metrics correlation with goals per game')

figure
hold on
for i = 1:7
    plot(allest([2:6,10,11],2+(i-1)*2),'o')
end
hold off
legend('England','Euro','France','Germany','Italy','Spain','World Cup')
title('Loseball correlation with goals per game')