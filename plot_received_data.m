function y = read_usrp_data_file;

    f1 = fopen('rec.dat', 'r');
    tmp = fread(f1, 'float32');
    fclose(f1);
    y = tmp(1:2:end)+1i*tmp(2:2:end);
%     plot(y);
    
end

%PS C:\Program Files\UHD\lib\uhd\examples> .\rx_samples_to_file.exe --file "C:\Users\ipaul\Documents\ADC\ADCfinal\rec.dat" --freq 2497000000 --rate 100000 --type float --gain 20