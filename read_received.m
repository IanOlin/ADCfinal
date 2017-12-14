%% Transmission / Reception parmaeters
% sampling_rate = 500000 samples/second
% frequency = 2497000000 Hz

pulse_length = 100;
%% Read data files
% known.dat is the file containing known white noise. This will be used to
% aid us in finding the beginning of our data vector.
f1 = fopen('known1212.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
known = tmp(1:2:end)+1i*tmp(2:2:end);
plot(tmp(2:2:end))

% The received signal. Contains a section of random white noise, a section
% of known white noise, and the data vector.
f1 = fopen('rx12122.dat', 'r');
tmp = fread(f1,'float32');
fclose(f1);
rx = tmp(1:2:end)+1i*tmp(2:2:end);

%% Find start of data using the known noise
close all;
% cross correlate the received data with the known noise to find the
% midpoint of the known noise in the received vector.

[corr, lags] = xcorr(rx, known);
%find the maximum amplitude in the fft.
[~, I] = max(abs(corr));
t = lags(I);
%% 
% figure; hold on;
% start_data = abs(t + (length(known) / 2));
start_data = 917208 + 10000 + 50;
end_data = 1.896e6;

% data_only = rx(start_data: end_data); % Use portion of the data
plot(real(rx))
pause

% data_only = rx(1e6:4e6);
data_only = rx(7e5:5.65e6);

%% Correct for offsets
chunk_size = 1e4;
Kp = 30;
Ki = 10;
Kd = 0;

corrected = correct_frequency_drift(chunk_size, data);
looped = phase_locked_loop(corrected, 30, 10, 0);

threshold_real = (real(looped) > 0) - (real(looped) <= 0);
threshold_imag = (imag(looped) > 0) - (imag(looped) <= 0);

figure; 
plot(downsample(looped(pulse_length / 2:end), pulse_legth), '.');

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
        
 