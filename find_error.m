% tx_test = sampled_tx_real(1:end-1);
% rx_test = sampled_threshold_real(16:length(tx_test)+15);
sampled_tx_real = sampling(real(tx) ./ .6);
sampled_tx_imag = sampling(imag(tx) ./ .6);
sampled_threshold_imag = sampling(threshold_imag(62:end));
sampled_threshold_real = sampling(threshold_real(62:end));
tx_test = sampled_tx_real(1:end-1);
rx_test = sampled_threshold_real(16:length(tx_test)+15);
error_matrix = tx_test-rx_test;
errors = nnz(error_matrix);
errors/length(error_matrix)

% SPS C:\Program Files\UHD\lib\uhd\examples> ./tx_samples_from_file --file C:\Users\ipaul\Documents\ADC\ADCfinal\tx1212.da
% t --rate 500000 --freq 2497000000 --gain 30 --type float


