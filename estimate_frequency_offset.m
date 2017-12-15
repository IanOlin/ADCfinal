function [p_est, f_est, freq, amp] = estimate_frequency_offset(y)
   % Estimate the frequency offset of a received signal.
   % y: the received signal.
   % f_est: the frequency offset estimate in radians.
   Y = (fftshift(fft(y.^4)));
   fs = linspace(-pi, pi * (length(Y) - 1) / length(Y), length(Y));
   [h4, I] = max(Y);
   p_est = angle(h4) / 4;
   f_est = fs(I) / 4;
   freq = fs;
   amp = abs(Y);
end