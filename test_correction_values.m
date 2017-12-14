rx = read_usrp_data_file('rx12122.dat');
data = rx(1e6:5e6);

% Uncomment below to test various chunk sizes
% for i = 1e3:5e2:1e4
%     clf; plot(correct_frequency_drift(i, data), '.');
%     disp(i);
%     pause
% end

% This gives a reasonable separation.
corrected = correct_frequency_drift(1e4, data);

% Uncomment below and adjust intervals of i to test various pll parameter
% values
% for i = 1:10:50
%     [y, errors] = phase_locked_loop(corrected, i, 10, 0)
%     clf; plot(y, '.');
%     disp(i);
%     pause
% end

% Using the tests above, I found that these values were about as good as we
% could get with this data
[looped, errors] = phase_locked_loop(corrected, 30, 10, 0);
figure;
clf; subplot(1, 2, 1); plot(corrected, '.'); 
title('Frequency corrected');
subplot(1, 2, 2); 
plot(looped, '.');
title('Phase locked loop');