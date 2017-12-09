function f_est = estimate_frequency_offset(y)
   % Estimate the frequency offset of a received signal.
   % y: the received signal.
   % f_est: the frequency offset estimate in radians.
   Y1 = abs(fftshift(fft(y.^4)));
   fs = linspace(-pi, pi, length(Y1));
   plot(fs, Y1);
   [~, I] = max(Y1);
   f_est = fs(I(1)) / 4;
   disp(f_est);
end