function y = phase_locked_loop(Ztotal, Kp, Ki, Kd)

% QEA FINAL RUSSIAN WEATHER SATELLITE! 
% Zi = input1; %will get this value from the USRP
% Zq = input2; %will get this value from the USRP 
% 
% Zq = 1i*Zq; 

% Ztotal = Zi + Zq; %this is a complex number Zi + iZq
y = zeros(size(Ztotal)); 

phi = 0; 
oldPhi = 0;
sumPhi = 0; 

for k = 1:length(Ztotal) 
    y(k) = Ztotal(k)*exp(-1i*phi); 

    realPart = real(y(k)); 
    imagPart = imag(y(k));

    signReal = sign(realPart);
    signImag = sign(imagPart); 

    realPart = signImag*realPart;
    imagPart = signReal*imagPart; 

    phi = -1*(realPart - imagPart)/2; 
    sumPhi = sumPhi + phi;
    phi = Kp*phi + Ki*(sumPhi) + Kd*(phi - oldPhi); 
    
    oldPhi = phi; 
end

% bits = Ztotal.*exp(1i*phi); 
% firstBits = sign(real(bits));
% secondBits = sign(imag(bits)); 
end