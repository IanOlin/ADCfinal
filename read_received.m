%% Transmission / Reception parmaeters
sampling_rate = 500000;  % samples/second
frequency = 2497000000; % Hz
pulse_length = 10;
upsample = 100;
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
% 10, 15, 0
% Kp = 10;
% Ki = 15;
% Kd = 0;
% locked = phase_locked_loop(data_only, Kp, Ki, Kd);
% plot(locked, '*');

Kp2 = 10;
Ki2 = 100;
Kd2 = 0;

corrected = zeros(length(data_only),1);

chunk_size = 5e4;
num_chunks = floor(length(data_only) / chunk_size);
drift = zeros(num_chunks, 1);
for i = 1:num_chunks
    start_index = (i - 1) * chunk_size + 1;
    end_index = (i * chunk_size);
    data_chunk = data_only(start_index: end_index);
    [p_est, f_est, freq, amp] = estimate_frequency_offset(data_chunk);
%     if mod(i, 100) == 0
%         plot(freq, amp)
%         pause
%     end
    drift(i) = f_est;
    corrected(start_index: end_index) =  (data_only(start_index: end_index) .* exp(-1i * f_est .*[0:chunk_size-1]' - 1i * p_est));

%     plot(corrected(start_index:end_index), '*')
%     pause
end
%%
% averaged = zeros(length(data_only),1);
% window = 2000;
% num_windows = floor(length(data_only) / window);
% for i = 1:num_windows
%     start_index = (i - 1) * window + 1;
%     end_index = (i * window);
%     averaged(start_index:end_index) = ones(window, 1) * mean(corrected(start_index:end_index));
% end

% for i = 1:num_windows
%     start_index = (i - 1) * window + 1;
%     end_index = (i * window);
%     averaged(start_index:end_index) = ones(window, 1) * mean(corrected(start_index:end_index));
% end
    
% corrected = corrected .* exp(pi/4);
% figure
% plot(corrected , '*');
% figure;
% plot(real(corrected));
% hold on;
% plot(imag(corrected));



% t = linspace(0, length(data_only) / 250000, length(data_only)); 

% frequency_corrected = data_only .* exp(-1i * f_est .*t');
% phase_corrected = frequency_corrected ./ p_est;
% 
% figure;
% plot(frequency_corrected, '*');
% figure;
% plot(phase_corrected, '*');


% threshold_real = (real(locked) > 0) - (real(locked) <= 0);
% threshold_imag = (imag(locked) > 0) - (imag(locked) <= 0);

% d_corrected = downsample(corrected, 2 * upsample);
threshold_real = (real(corrected) > 0) - (real(corrected) <= 0);
threshold_imag = (imag(corrected) > 0) - (imag(corrected) <= 0);

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
        
 