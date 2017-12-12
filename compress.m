function comp_rate = compress(infile,resolution,outfile)
% This code borrows heavily from:
%*****************************************************************
% Luigi Rosa
% Via Centrale 27
% 67042 Civita di Bagno
% L'Aquila --- ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 340 3463208 
% http://utenti.lycos.it/matlab
%*****************************************************************

if (exist(infile)==2)
    pic = imread(infile);
    figure('Name','Input image');
    imshow(pic);
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
tmp = zeros(6*numel(encmat_r),1);
tmp(1:6:end) = real(encmat_r);
tmp(2:6:end) = imag(encmat_r);
tmp(3:6:end) = real(encmat_g);
tmp(4:6:end) = imag(encmat_g);
tmp(5:6:end) = real(encmat_b);
tmp(6:6:end) = imag(encmat_b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data has been encoded as binary and compiled to an array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write transmission file
f1 = fopen(outfile, 'w');
fwrite(f1, tmp, 'float32');
fclose(f1);

return

end