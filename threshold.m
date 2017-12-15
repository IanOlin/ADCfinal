function [threshold_real, threshold_imag] = threshold(x)
% x: a complex vector to threshold into +-1+-i values.
% threshold_real: the real part of the thresholded signal
%treshold_imag: the imaginary part of the  thresholded signal

threshold_real = (real(x) > 0) - (real(x) <= 0);
threshold_imag = (imag(x) > 0) - (imag(x) <= 0);
end