% x = ones(1000000, 1);
% for i = 1:length(x)/500
%     x((i - 1) * 500 + 1: (i - 1) * 500 + 250) = -1;
% end


% x = x * .6;

x1 = wgn(10000, 1, 1);

f1 = fopen('known.dat', 'r');
x2 = fread(f1,'float32');
fclose(f1);

t = 0:1/2.5e6:3;
x3 = .6*square(2*pi*1000*t);

x = [x1;x2;x3.'];
write_usrp_data_file(x);

% ./tx_samples_from_file --file C:\Users\aolson\Documents\MATLAB\AnalogDigitalcomm\Final\tx.dat --rate 2500000 --freq 2497000000 --gain 20 --type float

% C:\Program Files\UHD\lib\uhd\examples