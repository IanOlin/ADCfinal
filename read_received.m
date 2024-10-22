%% Transmission / Reception parmaeters
% sampling_rate = 500000 samples/second
% frequency = 2497000000 Hz

pulse_length = 50;
%% Read data files
% The transmitted signal.
tx = read_usrp_data_file('tx.dat');

% The received signal. Contains a section of random white noise, a section
% of known white noise, and the data vector.
rx = read_usrp_data_file('rx.dat');

pulse_size = 15;
pulse = ones(1, pulse_size);
headfoot = ones(30, 1);
headfoot = 2*upsample(headfoot, 3) - 1;
headfoot = conv(ones(1, pulse_size), upsample(headfoot, pulse_size));

%% Find start of data using the known noise
close all;

% Chop off the beginning noise.
amplitude_threshold = 0.02;
estimated_start = find(rx > amplitude_threshold);

% % % % cross correlate the received data with the known noise to find the
% % % % midpoint of the known noise in the received vector.
% % % [corr, lags] = xcorr(rx, headfoot);
% % % 
% % % %find the maximum amplitude in the fft.
% % % [~, I] = max(abs(corr));
% % % t = lags(I);
% data_only = rx(1e6:4e6);
data_only = rx(estimated_start: end);

%% Correct for offsets
chunk_size = 1e4;
Kp = 30;
Ki = 10;
Kd = 0;

corrected = correct_frequency_drift(chunk_size, data_only);
looped = phase_locked_loop(corrected, 30, 10, 0);

threshold_real = (real(looped) > 0) - (real(looped) <= 0);
threshold_imag = (imag(looped) > 0) - (imag(looped) <= 0);

figure; 
plot(downsample(looped(pulse_length / 2:end), pulse_length), '.');

% figure;
% plot(threshold_imag, '*')
% figure;
% plot(threshold_real, 'o')
% 
% threshold_real = (real(averaged) > 0) - (real(averaged) <= 0);
% threshold_imag = (imag(averaged) > 0) - (imag(averaged) <= 0);

% figure;
% plot(threshold_imag, '*')
% figure;
% plot(threshold_real, 'o')
% plot(x)
        
 