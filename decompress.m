function rest_im = decompress(infile, [resolution], im_size)
% This code borrows from
%*****************************************************************
% Luigi Rosa
% Via Centrale 27
% 67042 Civita di Bagno
% L'Aquila --- ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 340 3463208 
% http://utenti.lycos.it/matlab
%*****************************************************************
    
    % Read data file and store rgb matrices
    f1 = fopen(infile, 'r');
    tmp = fread(f1,'float32');
    fclose(f1);
    comp_r = zeros(size(tmp(1:6:end));
    comp_g = comp_r;
    comp_b = comp_r;
    comp_r(1:2:end) = (tmp(1:6:end)==1)
    comp_r(2:2:end) = tmp(2:6:end);
    comp_g = tmp(3:6:end)+1i*tmp(4:6:end);
    comp_b = tmp(5:6:end)+1i*tmp(6:6:end);
    
    % Make dummy matrix for image & populate
    im = [resolution(1);resolution(2);3];
    val_space = size
    im()
    
    plot(y);
    im=zeros(size(red,1),size(red,2),3);

    im(1:row_bound,1:col_bound,1)=comp_r;
    im(1:row_bound,1:col_bound,2)=comp_g;
    im(1:row_bound,1:col_bound,3)=comp_b;

    im(:,:,1)=idct2(im(:,:,1));
    im(:,:,2)=idct2(im(:,:,2));
    im(:,:,3)=idct2(im(:,:,3));


    im=uint8(im);

    figure('Name','Output image');
    imshow(im);

end