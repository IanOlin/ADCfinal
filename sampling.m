function sampled = sampling(values)
sampled = zeros(floor(length(values)/100),1);
for i = 1:100:length(values)-100
    value = 0;
    for j = 1:1:99
        value = value + values(i+j);
    end
    if value > 90
        sampled( (i-1)/100 +1) = 1;
    elseif value < -90
        sampled( (i-1)/100 +1) = -1;
        % Add a threshold value, with a failure in confidence go to 0
    else
        sampled( (i-1)/100 +1) = 0;
    end
end




% sampled_threshold_real = zeros(floor(length(threshold_real)/100),1);
% sampled_threshold_imag = zeros(floor(length(threshold_imag)/100),1);
% for i = 1:100:length(threshold_real)
%     value = 0;
%     for j = 1:1:99
%         value = value + threshold_real(i+j);
%     end
%     if value > 0
%         sampled_threshold_real( (i-1)/100 +1) = 1;
%     elseif value <0
%         sampled_threshold_real( (i-1)/100 +1) = -1;
%         % Add a threshold value, with a failure in confidence go to 0
%     end
% end