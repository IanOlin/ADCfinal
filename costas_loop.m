function est_x = costas_loop(y, alpha)
% Process a received signal using a Costas' loop to correct for phase
% offset. Assume that noise is negligible.
% y: the received signal.
% alpha: the proportion of the previous frequency offset that makes up the
% new estimate.
% returns: est_x is an estimate of the transmitted signal corrected for
% phase and frequency offset.
    f_delta = estimate_frequency_offset(y);
    x_hat = ones(size(y, 1), size(y, 2));
    for i = 1:length(x_hat)
        x_hat(i) = exp(-1i * f_delta) * y(i);
        error = -real(y(i)) * imag(y(i));
        f_delta = alpha * f_delta - (1 - alpha) * error;
    end
    est_x = x_hat;
end
