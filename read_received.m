clear all;
f1 = fopen('known.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
known = tmp(1:2:end)+1i*tmp(2:2:end);
plot(tmp(2:2:end))

f1 = fopen('rx1209.dat', 'r');
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

% figure; hold on;
start_data = (t + 10 * (length(known) / 2));
data_only = rx(start_data: start_data + 8e5);
% subplot(2,1,1); plot(real(data_only));
% subplot(2,1,2); plot(imag(data_only));

Kp = 10;
Ki = 15;
Kd = 0;
locked = phase_locked_loop(data_only, Kp, Ki, Kd);
plot(locked, '*');

threshold_real = (real(locked) > 0) - (real(locked) <= 0);
threshold_imag = (imag(locked) > 0) - (imag(locked) <= 0);

bit_error
 