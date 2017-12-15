function [image, signal, percent_error] = receive_image()
% Read a data file containing a transmitted signal,and decode into an
% image.

% image: the received image
% signal: the received signal corrected for frequency and phase offset, and
% truncated to only contain the transmitted signal.

% Transmission parameters
sampling_rate = 5e5; % samples/second
pulse_length = 100; % number of samples per data bit
length_message = 2e6; % number of total samples in transmitted message
% The known white noise transmitted preceding the header
known_noise = read_usrp_data_file('known1212.dat');
length_known = length(known);

% The known signal at the beginning of the data
header = read_usrp_data_file('known1212.dat');

% The received signal
rx = read_usrp_data_file('rx122122.dat');

% Cross correlate to find the beginning of the data
[corr, lags] = xcorr(rx, known);
[~, I] = max(abs(corr));
t_mid_known = lags(I); % The midpoint of the knkown noise in the received signal.
t_start_header = t_mid_known + (2 * 10 * length_known);

data_signal = rx(t_start_header:t_start_header + length_message);

% Correct for frequency and phase drift
chunk_size = 1e4;
corrected = correct_frequency_drift(chunk_size, data_signal);

end