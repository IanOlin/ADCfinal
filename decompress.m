function res = decompress(data, resolution, im_size)
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
    
    close all
    
    % Read data and store rgb matrices
    r_vals = data(1:3:end);
    g_vals = data(2:3:end);
    b_vals = data(3:3:end);
    
    % Make strings for rgb binary values
    r_bin = '';
    g_bin = '';
    b_bin = '';
    
    % Populate binary data strings
    for i = 1:numel(r_vals)
        % red vals
        if r_vals(i) == 1+1i
            r_bin = strcat(r_bin,'11');
        elseif r_vals(i) == 1-1i
            r_bin = strcat(r_bin,'10');
        elseif r_vals(i) == -1+1i
            r_bin = strcat(r_bin,'01');
        elseif r_vals(i) == -1-1i
            r_bin = strcat(r_bin,'00');
        end
        % green vals
        if g_vals(i) == 1+1i
            g_bin = strcat(g_bin,'11');
        elseif g_vals(i) == 1-1i
            g_bin = strcat(g_bin,'10');
        elseif g_vals(i) == -1+1i
            g_bin = strcat(g_bin,'01');
        elseif g_vals(i) == -1-1i
            g_bin = strcat(g_bin,'00');
        end
        % blue vals
        if b_vals(i) == 1+1i
            b_bin =strcat(b_bin,'11');
        elseif b_vals(i) == 1-1i
            b_bin = strcat(b_bin,'10');
        elseif b_vals(i) == -1+1i
            b_bin = strcat(b_bin,'01');
        elseif b_vals(i) == -1-1i
            b_bin = strcat(b_bin,'00');
        end
    end
    
    % Cut long strings into 64bit binary strings
    r_bin = cell2mat(cellstr(reshape(r_bin,32,[])'));%(regexp(r_bin, '\w{1,32}', 'match'));
    g_bin = cell2mat(cellstr(reshape(g_bin,32,[])'));
    b_bin = cell2mat(cellstr(reshape(b_bin,32,[])'));
    
    % Convert to decimal
    q = quantizer('single');
    comp_r = bin2num(q,r_bin);
    comp_g = bin2num(q,g_bin);
    comp_b = bin2num(q,b_bin);
    size (comp_r)
    
    % Reshape matrices to desired compressed size
    comp_r = reshape(comp_r,resolution);
    comp_g = reshape(comp_g,resolution);
    comp_b = reshape(comp_b,resolution);
    
    % Create dummy matrices for image
    im = zeros(im_size(1),im_size(2),3);
    
    % Populate matrices
    im(1:resolution(1),1:resolution(2),1) = comp_r;
    im(1:resolution(1),1:resolution(2),2) = comp_g;
    im(1:resolution(1),1:resolution(2),3) = comp_b;

    % Inverse cosine transform
    im(:,:,1)=idct2(im(:,:,1));
    im(:,:,2)=idct2(im(:,:,2));
    im(:,:,3)=idct2(im(:,:,3));

    % Convert to uint8 format for image display
    im=uint8(im);

    % Display Image
    figure('Name','Output image');
    imshow(im);
    
    return
end