function rest_im = decompress(infile, outfile)
% This code borrows heavily from
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
    a = imread(infile);
    figure('Name','Input image');
    imshow(a);
else
    warndlg('The file does not exist.',' Warning ');
    im=[];
    return
end

end