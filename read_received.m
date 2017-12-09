clear all;
f1 = fopen('known.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
known = tmp(1:2:end)+1i*tmp(2:2:end);
plot(tmp(2:2:end))

f1 = fopen('rx1.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
rx = tmp(1:2:end)+1i*tmp(2:2:end);

close all;
% subplot(3, 1, 1);
% plot(abs(rx));
[corr, lags] = xcorr(rx, known);
% plot(lags, corr)
[~, I] = max(abs(corr));
t = lags(I);

figure; hold on;
data_only = rx((t + 10 * (length(known) / 2)):end);
subplot(2,1,1); plot(real(data_only));
subplot(2,1,2); plot(imag(data_only));
locked = costas_loop(data_only, .1);