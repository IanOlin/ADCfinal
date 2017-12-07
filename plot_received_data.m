% function y = read_usrp_data_file;
% 
%     f1 = fopen('rec.dat', 'r');
%     tmp = fread(f1, 'float32');
%     fclose(f1);
%     y = tmp(1:2:end)+1i*tmp(2:2:end);
% %     plot(y);
%     count = sum(tmp(:)>0.5)
%     
% end

f1 = fopen('rec.dat', 'r');
tmp = fread(f1, 'float32');
fclose(f1);
y = tmp(6e5:2:end)+1i*tmp(6e5:2:end);
% plot(abs(y));
plot(xcorr(abs(y),abs(y)));
count = sum(abs(y)>.003);
% figure;
% plot(y);
%PS C:\Program Files\UHD\lib\uhd\examples> .\rx_samples_to_file.exe --file "C:\Users\ipaul\Documents\ADC\ADCfinal\rec.dat" --freq 2497000000 --rate 2500000 --type float --gain 20