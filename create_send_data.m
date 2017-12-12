% x = ones(1000000, 1);
% for i = 1:length(x)/500
%     x((i - 1) * 500 + 1: (i - 1) * 500 + 250) = -1;
% end


% x = x * .6;

x1 = wgn(10000, 1, 1);

f1 = fopen('known1212.dat', 'r');
x2 = fread(f1,'float32');
fclose(f1);

% t = 0:1/2.5e6:3;
% x3 = .6*square(2*pi*1000*t) + .6*i*square(2*pi*t*500);


fileTx = 'thumb.jpg';            % Image file name
fData = imread(fileTx);            % Read image data from file
binData = dec2bin(fData(:)); % Make binary
binData = reshape(binData,[],2); %Make into Xx2
% binData = str2double(binData);
% x3 = zeros(1:length(binData));
clear x3
for i = 1:1:length(binData)
    value = 0;
    if binData(i,1) == '0'
        value = -.6;
    elseif binData(i,1) == '1'
        value = .6;
    end
    
    if binData(i,2) == '0'
        value = value - .6j;
    elseif binData(i,2) == '1'
        value = value +.6j;
    end
    
    x3(i) = value;
end

x3 = repelem(x3, 100);

% decode_test = x3(1:10:end);
% for i = 1:1:length(decode_test)
%     if decode_test(i) == .6+.6j
%         value = ('11');
%     elseif decode_test(i) == .6 -.6j
%         value = ('10');
%     elseif decode_test(i) == -.6 + .6j
%         value = ('01');
%     elseif decode
%     end
% end

x = [x1;x2;x3.'];
write_usrp_data_file(x);

% ./tx_samples_from_file --file C:\Users\aolson\Documents\MATLAB\AnalogDigitalcomm\Final\tx.dat --rate 2500000 
% --freq 2497000000 --gain 20 --type float

% C:\Program Files\UHD\lib\uhd\examples