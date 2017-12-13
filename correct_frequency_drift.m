function corrected = correct_frequency_drift(chunk_size, data)
    % Estimate and correct for frequency and phase drift in a complex data
    % signal. 
    % chunk_size: the number of data points to correct for at a time.
    % data: A data vector of complex values
    corrected = zeros(size(data));
    num_chunks = floor(length(data) / chunk_size);
    for i = 1:num_chunks
        start_index = (i - 1) * chunk_size + 1;
        end_index = i * chunk_size;
        chunk = data(start_index:end_index);
        [p_est, f_est, ~, ~] = estimate_frequency_offset(chunk);
        % Below is testing the option of not multiplying p_est by 1i. Not
        % sure if it's better.
%         corrected(start_index:end_index) = chunk .* exp(-1i * f_est .* (0:chunk_size - 1)' - 1i * p_est);
        corrected(start_index:end_index) = chunk .* exp(-1i * f_est .* (0:chunk_size - 1)') * exp(-p_est);
    end   
end