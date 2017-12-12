function [p_est, f_est] = estimate_frequency_offset(y)
   % Estimate the frequency offset of a received signal.
   % y: the received signal.
   % f_est: the frequency offset estimate in radians.
   y = y./rms(y);
   Y = (fftshift(fft(y.^4)));
   fs = linspace(-pi, pi * (length(Y) - 1) / length(Y), length(Y));
%    plot(fs, abs(Y))
   [h4, I] = max(Y);
   disp(h4);
   p_est = h4.^(1/4);
   f_est = fs(I) / 4;
end