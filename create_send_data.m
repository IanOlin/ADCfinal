% x = ones(1000000, 1);
% for i = 1:length(x)/500
%     x((i - 1) * 500 + 1: (i - 1) * 500 + 250) = -1;
% end


% x = x * .6;

% x1 = wgn(10000, 1, 1);

% f1 = fopen('known1212.dat', 'r');
% x2 = fread(f1,'float32');
% fclose(f1);

% x2 = read_usrp_data_file('known1212.dat');

% t = 0:1/2.5e6:3;
% x3 = .6*square(2*pi*1000*t) + .6*i*square(2*pi*t*500);


% fileTx = 'thumb.jpg';            % Image file name
% fData = imread(fileTx);            % Read image data from file
% binData = dec2bin(fData(:)); % Make binary
% binData = reshape(binData,[],2); %Make into Xx2
% % binData = str2double(binData);
% % x3 = zeros(1:length(binData));
% clear x3
% for i = 1:1:length(binData)
%     value = 0;
%     if binData(i,1) == '0'
%         value = -.6;
%     elseif binData(i,1) == '1'
%         value = .6;
%     end
%     
%     if binData(i,2) == '0'
%         value = value - .6j;
%     elseif binData(i,2) == '1'
%         value = value +.6j;
%     end
%     
%     x3(i) = value;
% end

% compress('thumb.jpg',900,'tx1212.dat')

% x3 = repelem(x3, 100);

% upsample_size = 100;
% x3 = rcosflt(x3, 1, upsample_size);

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

% x = [x1;x2;x3];
% write_usrp_data_file(x);

% ./tx_samples_from_file --file C:\Users\aolson\Documents\MATLAB\AnalogDigitalcomm\Final\tx.dat --rate 2500000 
% --freq 2497000000 --gain 20 --type float

% C:\Program Files\UHD\lib\uhd\examples

infile = 'thumb.jpg';
resolution = 900;
outfile = 'tx1212.dat';

if (exist(infile)==2)
    pic = imread(infile);
%     figure('Name','Input image');
%     imshow(pic);
else
    disp('Warning: file does not exist')
    return
end

% Extract rgb values by color
% Set to double rather than uint8 for calculations
red = double(pic(:,:,1));
green = double(pic(:,:,2));
blue = double(pic(:,:,3));

% Take dct of color vectors
red_dct = dct2(red);
green_dct = dct2(green);
blue_dct = dct2(blue);

% Convert to power rather than intensity
red_pow = red_dct.^2;
green_pow = green_dct.^2;
blue_pow = blue_dct.^2;


% Organize into single column for sorting
red_pow = red_pow(:);
green_pow = green_pow(:);
blue_pow = blue_pow(:);

% Sort from greatest to least and store indices
[S_r,index_r] = sort(red_pow,'descend');
[S_g,index_g] = sort(green_pow,'descend');
[S_b,index_b] = sort(blue_pow,'descend');

% Create vectors to contain highest powered values
comp_r = zeros(size(red));
comp_g = zeros(size(green));
comp_b = zeros(size(blue));

% Populate matrices with highest powered values
 for i = 1:resolution
    comp_r(index_r(i)) = red_dct(index_r(i));
    comp_g(index_g(i)) = green_dct(index_g(i));
    comp_b(index_b(i)) = blue_dct(index_b(i));
 end

% Find bounds of matrices that are nonzer0
red_nz = [find(any(comp_r,2),1,'last'),find(any(comp_r,1),1,'last')];
green_nz = [find(any(comp_g,2),1,'last'),find(any(comp_g,1),1,'last')];
blue_nz = [find(any(comp_b,2),1,'last'),find(any(comp_b,1),1,'last')];

% Find greatest bounds of rows and columns
row_bound = max([red_nz(1),green_nz(1),blue_nz(1)]);
col_bound = max([red_nz(2),green_nz(2),blue_nz(2)]);

% Resize matrices to contain only useful data
comp_r = comp_r(1:row_bound,1:col_bound);
comp_g = comp_g(1:row_bound,1:col_bound);
comp_b = comp_b(1:row_bound,1:col_bound);

% Calculate compression rate
comp_rate = 100*numel(comp_r)/numel(red);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data has been compressed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert doubles to binary strings
q = quantizer('double');
enc_r = num2bin(q, comp_r);
enc_g = num2bin(q, comp_g);
enc_b = num2bin(q, comp_b);

% Set forloop bounds
indices = size(enc_r);

% Loop to convert binary to complex symbols in 3 matrices
spot = 0;
for j = 1:2:indices(1)
    for k = 1:2:indices(2)
        num_r = enc_r(j,k:k+1);
        num_g = enc_g(j,k:k+1);
        num_b = enc_b(j,k:k+1);
        spot = spot+1;
        if strcmp(num_r,'11')
            encmat_r(spot) = (1+1i);
        elseif strcmp(num_r,'10')
            encmat_r(spot) = (1-1i);
        elseif strcmp(num_r,'01')
            encmat_r(spot) = (-1+1i);
        elseif strcmp(num_r,'00')
            encmat_r(spot) = (-1-1i);
        end
        if strcmp(num_g,'11')
            encmat_g(spot) = (1+1i);
        elseif strcmp(num_g,'10')
            encmat_g(spot) = (1-1i);
        elseif strcmp(num_g,'01')
            encmat_g(spot) = (-1+1i);
        elseif strcmp(num_g,'00')
            encmat_g(spot) = (-1-1i);
        end
        if strcmp(num_b,'11')
            encmat_b(spot) = (1+1i);
        elseif strcmp(num_b,'10')
            encmat_b(spot) = (1-1i);
        elseif strcmp(num_b,'01')
            encmat_b(spot) = (-1+1i);
        elseif strcmp(num_b,'00')
            encmat_b(spot) = (-1-1i);
        end
    end
end

% Compile symbols as rgb array
tmp = zeros(3*numel(encmat_r),1);
% tmp(1:6:end) = real(encmat_r);
% tmp(2:6:end) = imag(encmat_r);
% tmp(3:6:end) = real(encmat_g);
% tmp(4:6:end) = imag(encmat_g);
% tmp(5:6:end) = real(encmat_b);
% tmp(6:6:end) = imag(encmat_b);
tmp(1:3:end) = encmat_r;
tmp(2:3:end) = encmat_g;
tmp(3:3:end) = encmat_b;

tmp = tmp .* .6;
tmp =  repelem(tmp, 100);

% upsample_size = 15;
pre_ones = ones(10000,1);
pre_zeros = zeros(10000,1);
% tmp =  repelem(tmp, 100);
% tmp = rcosflt(tmp, 1, upsample_size);
tmp = [pre_ones;pre_zeros;tmp];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data has been encoded as binary and compiled to an array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write transmission file
% f1 = fopen(outfile, 'w');
% fwrite(f1, tmp, 'float32');
% fclose(f1);

write_usrp_data_file(tmp);

return