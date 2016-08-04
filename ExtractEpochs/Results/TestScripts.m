
for idx = 16:length(labels)
simple(idx) = 0.9*mean(labels(idx-15:idx-1))+0.1*labels(idx);
end
figure;plot(simple);

for idx = 21:length(labels)
simple(idx) = mean(labels(idx-20:idx));
end
figure;plot(simple);
simple(1:20) = 0;
figure;plot(21:length(simple), simple(21:end));

plot(labels);
hold on;
plot(21:length(simple), simple(21:end));