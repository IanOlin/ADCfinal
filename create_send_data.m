x = ones(100000, 1);
x = x * .6;
write_usrp_data_file(x);

% ./tx_samples_from_file --file
% C:\Usets\aolson\Documents\MATLAB\AnalogDigitalcomm\Final\tx.dat --rate
% 2500000 --freq 2497000000 --gain 20 --type float

% C:\Program Files\UHD\lib\uhd\examples