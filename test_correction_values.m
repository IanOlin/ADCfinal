close all

rx = read_usrp_data_file('rx1214.dat');
tx = read_usrp_data_file('tx.dat');

est_start = find(rx > 0.02);
% tx = read_usrp_data_file('tx1212.dat');
data = rx(est_start(1):end);

pulse_size = 15;
pulse = ones(1, pulse_size);
headfoot = ones(30, 1);
headfoot = 2*upsample(headfoot, 3) - 1;
headfoot = conv(ones(1, pulse_size), upsample(headfoot, pulse_size));
%%
% Uncomment below to test various chunk sizes
% for i = 3e4:1e2:5e4
%     c = correct_frequency_drift(i, data);
%     clf; plot(downsample(c, 50), '.');
%     disp(i);
%     pause
% end
%%
% This gives a reasonable separation.
corrected = correct_frequency_drift(4.1e4, data);
%%
% Uncomment below and adjust intervals of i to test various pll parameter
% values
% for i = 0:.5:5
%     y = phase_locked_loop(corrected, .5, i, 0);
%     clf; plot(y, '.');
%     disp(i);
%     pause
% end
%%
% Using the tests above, I found that these values were about as good as we
% could get with this data
looped = phase_locked_loop(corrected, 0.5, 4, 0);
figure;
clf; subplot(1, 2, 1); plot(downsample(corrected, 50, 25), '.'); 
title('Frequency corrected');
subplot(1, 2, 2); 
plot(downsample(looped, 50, 25),'.');
title('Phase locked loop');

[corr, lags] = xcorr(looped, headfoot);
[~, I] = max(corr);
start = lags(I) - length(headfoot) * 10 / 2;
endd = start + length(tx);
plot((0:length(data) - 1), data, start, 0, 'o', endd, 0, 'x');

data_only_looped = looped(start:end);

[threshold_real, threshold_imag] = threshold(data_only_looped);
threshold_total = threshold_real + threshold_imag * 1i;
sampled_real = sampling(threshold_real(1540:end));
sampled_imag = sampling(threshold_imag(1540:end));
close;

plot(sampled_real, '*');