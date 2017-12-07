% x = ones(1000000, 1);
% for i = 1:length(x)/500
%     x((i - 1) * 500 + 1: (i - 1) * 500 + 250) = -1;
% end


% x = x * .6;

x = wgn(10000000, 1, 1);
write_usrp_data_file(x);

% ./tx_samples_from_file --file C:\Users\aolson\Documents\MATLAB\AnalogDigitalcomm\Final\tx.dat --rate 2500000 --freq 2497000000 --gain 20 --type float

% C:\Program Files\UHD\lib\uhd\examples