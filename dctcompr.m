function comp_rate = dctcompr (infile,coeff,outfile)
% I DID NOT WRITE THIS CODE
%I did update it a bit, though

% DCTCOMPR (infile,coeff,outfile)
% Image compression based on Discrete Cosine Transform.
%  infile is input file name present in the current directory
%  coeff is the number of coefficients with the most energy
%  outfile is output file name which will be created
%
% For more details concernings the algorithm implemented please visit the following links:
% 
%  http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4328&objectType=file
%  http://www.ece.purdue.edu/~ace/jpeg-tut/jpegtut1.html

%*****************************************************************
% Luigi Rosa
% Via Centrale 27
% 67042 Civita di Bagno
% L'Aquila --- ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 340 3463208 
% http://utenti.lycos.it/matlab
%*****************************************************************
%

close all

if (exist(infile)==2)
    a = imread(infile);
    figure('Name','Input image');
    imshow(a);
else
    warndlg('The file does not exist.',' Warning ');
    im=[];
    return
end

    red = double(a(:,:,1));
    green = double(a(:,:,2));
    blue = double(a(:,:,3));

    red_dct=dct2(red);
    green_dct=dct2(green);
    blue_dct=dct2(blue);

    red_pow   = red_dct.^2;
    green_pow = green_dct.^2;
    blue_pow  = blue_dct.^2;

    red_pow=red_pow(:);
    green_pow=green_pow(:);
    blue_pow=blue_pow(:);

    [B_r,index_r]=sort(red_pow);
    [B_g,index_g]=sort(green_pow);
    [B_b,index_b]=sort(blue_pow);

    index_r=flipud(index_r);
    index_g=flipud(index_g);
    index_b=flipud(index_b);

    im_dct_r=zeros(size(red));
    size(red)
    im_dct_g=zeros(size(green));
    im_dct_b=zeros(size(blue));

    for ii=1:coeff
        im_dct_r(index_r(ii))=red_dct(index_r(ii));
        im_dct_g(index_g(ii))=green_dct(index_g(ii));
        im_dct_b(index_b(ii))=blue_dct(index_b(ii));
    end
    
    comp_r = nonzeros(im_dct_r);
    comp_g = nonzeros(im_dct_g);
    comp_b = nonzeros(im_dct_b);
    size(comp_r)
    size(comp_g)
    size(comp_g)

    im_r=idct2(im_dct_r);
    im_g=idct2(im_dct_g);
    im_b=idct2(im_dct_b);

    im=zeros(size(red,1),size(red,2),3);
    im(:,:,1)=im_r;
    im(:,:,2)=im_g;
    im(:,:,3)=im_b;

    im=uint8(im);

    imwrite(im, outfile);        

    figure('Name','Output image');
    imshow(im);
    
    comp_rate = 100*(3*coeff/numel(im));

end