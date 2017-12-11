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
comp_r = comp_r(1:row_bound,:);
comp_r = comp_r(:,1:col_bound);
comp_g = comp_g(1:row_bound,:);
comp_g = comp_g(:,1:col_bound);
comp_b = comp_b(1:row_bound,:);
comp_b = comp_b(:,1:col_bound)

tmp = zeros(3*numel(comp_r),1);
tmp(1:3:end) = comp_r;
tmp(2:3:end) = comp_g;
tmp(3:3:end) = comp_b;

comp_rate = 100*numel(comp_r)/numel(red);

im=zeros(size(red,1),size(red,2),3);
comp_r = padarray(comp_r,size(red));
comp_g = padarray(comp_g,size(green));
comp_b = padarray(comp_b,size(blue));
im(:,:,1)=comp_r;
im(:,:,2)=comp_g;
im(:,:,3)=comp_b;

im=uint8(im);

figure('Name','Output image');
imshow(im);

f1 = fopen(outfile, 'w');
fwrite(f1, tmp, 'float32');
fclose(f1);


end