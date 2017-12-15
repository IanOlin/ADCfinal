% Open the transmitted file

f1 = fopen('tx1212.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
tx = tmp(1:2:end)+1i*tmp(2:2:end);

f1 = fopen('rx12122.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
rx = tmp(1:2:end)+1i*tmp(2:2:end);

ttx = [0: length(tx) - 1];
trx = [0: length(rx) - 1];

plot(trx, abs(rx));

threshold_low = 0.01;
threshold_high = 0.03;
I = find(abs(rx) > threshold_low & abs(rx) < threshold_high);
figure
plot(trx, abs(rx), '.', I(1), abs(rx(I(1))), 'o');

start = [ones(1e4, 1); zeros(1e4, 1)];
[corr, lags] = xcorr(rx, tx);
plot(lags, abs(corr))

[~, I] = max(abs(corr));
t_start = abs(lags(I)) - 2.4e5;
t_end = t_start + length(tx) - 2e4;