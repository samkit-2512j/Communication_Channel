clear;clc;

audio_file='StarWars3.wav';
okok=audioread(audio_file);
[bitarr,fs]=antodig(audio_file);
% sound(okok,fs);
if mod(length(bitarr),2)~=0
    bitarr=[bitarr,0];
end
phases=fourfsk(bitarr);

stem(bitarr(767663:767762));
title("Sample of 16 bit A/D output")
ylabel("Digital bits")
figure;
stem(phases(383832:383881));
title("Corresponding output of the encoder")
ylabel("Symbol")

Rs=fs;
Ts=1/Rs;
Tb=0.001;

fc=10000;

nsymbols=length(phases);
nbits=nsymbols*2;

samples_per_symbol=297;

df=0.715/Tb;

M=4;
freqsep=3*df;

y=myfskmod(phases,4,freqsep,df,fc,fs);

m = 37;
a = 0.5;
l = 4;
transmit_filter = raised_cosine_2(a,m,l); % Raised Cosine

% transmit_filter = [ones(149,1);zeros(148,1)]; % Rect Pulse

% figure;
% stem(transmit_filter);
% title("Square Pulse");

figure;
stem(transmit_filter);
title("Raised Cosine Pulse");

tb=1/(samples_per_symbol*297):1/(samples_per_symbol*297):1/samples_per_symbol;
symbol0=cos(2*pi*(fc)*tb');
symbol1=cos(2*pi*(fc+df)*tb');
symbol2=cos(2*pi*(fc+2*df)*tb');
symbol3=cos(2*pi*(fc+3*df)*tb');

figure;
subplot(4,1,1);
plot(symbol0);
title("cos signal for symbol 00");
subplot(4,1,2);
plot(symbol1);
title("cos signal for symbol 01");
subplot(4,1,3);
plot(symbol2);
title("cos signal for symbol 11");
subplot(4,1,4);
plot(symbol3);
title("cos signal for symbol 10");
sgtitle("   Modulating signals")

figure;
subplot(4,1,1);
plot(abs(fftshift(fft(symbol0))));
title("FFT of cos signal for symbol 00");
subplot(4,1,2);
plot(abs(fftshift(fft(symbol1))));
title("FFT of cos signal for symbol 01");
subplot(4,1,3);
plot(abs(fftshift(fft(symbol2))));
title("FFT of cos signal for symbol 11");
subplot(4,1,4);
plot(abs(fftshift(fft(symbol3))));
title("FFT of cos signal for symbol 10");
sgtitle("   FFT of Modulating signals")

figure;
subplot(4,1,1);
plot(symbol0.*transmit_filter);
title("Signal for symbol 00");
subplot(4,1,2);
plot(symbol1.*transmit_filter);
title("Signal for symbol 01");
subplot(4,1,3);
plot(symbol2.*transmit_filter);
title("Signal for symbol 11");
subplot(4,1,4);
plot(symbol3.*transmit_filter);
title("Signal for symbol 10");
sgtitle("   Modulating signals multiplied with the Pulse")

% figure;
% plot(pwelch(y,5));
% title("PSD of the Modulated Signal");

b = 1;
lengtho = length(y)-b*297;

% snr=0:10;
% pe = zeros(size(snr));

delayedy = y(1:lengtho);
point = [zeros(297*b,1);delayedy];

% am = 0.5;
% y = am*y+(1-am)*point;
for n=1:length(phases)
    sym=(n-1)*297+1:n*297;
    y(sym)=y(sym).*transmit_filter;
end


figure;
plot(y(383832*297:383881*297))
title("Modulated Signal for symbols above");

figure;
plot(y(383850*297:383854*297));
title("All symbols");

% for i = 1:length(snr)
    
    noisy = awgn(y,1,1);

    % y=y+snr(i)/100*randn(size(y));
    % disp(snr(i));

% figure;
% plot(pwelch(y,5));
% title("PSD of Modulated Signal after adding noise")
figure;
plot(noisy(383832*297:383881*297))
title("Noisy Signal for symbols above");

figure;
plot(noisy(383850*297:383854*297));
title("Noisy symbols");

    demoded=myfskdemod(noisy,4,freqsep,df,fc,fs);
figure;
stem(demoded);
title("Demodulated Signal")
figure;
stem(demoded(383832:383881));
title("Demodulated Signal")

    error=0;
    received_bits=zeros(length(phases)*2,1);
    z=1;
    for n=1:length(demoded)
        if(demoded(n)~=phases(n))
          error=error+1;
        end
        if(demoded(n)==0)
            received_bits(z:z+1)=[0;0];
        elseif(demoded(n)==1)
            received_bits(z:z+1)=[0;1];
        elseif(demoded(n)==2)
            received_bits(z:z+1)=[1;1];
        else
            received_bits(z:z+1)=[1;0];
        end
    z=z+2;
    end

figure;
stem(received_bits(767663:767762));
title("Decoder output")
ylabel("Digital bits")

    error2=error/length(phases);

    % disp("Probability of error is "+error2+" for a = "+am+" and b = "+b);
    % pe(i) = error2;

% end

% figure;
% plot(snr,pe);
% title("P_{e} vs SNR plot");
% ylabel("P_{e}");
% xlabel("SNR");
char_array = num2str(received_bits); % Convert numeric array to character array
char_array = strrep(char_array.', ' ', ''); % Remove any spaces

binary_matrix = reshape(char_array.', [], 16); % Reshape back to matrix
audio_integers = bin2dec(binary_matrix); % Convert binary to decimal
audio_reconstructed = typecast(uint16(audio_integers), 'int16'); % Typecast to int16
audio_reconstructed_normalized = double(audio_reconstructed) / 32767; % Normalize to [-1, 1]

audiowrite('received.wav',audio_reconstructed_normalized,fs);

% Save the reconstructed audio

[lmao,fs]=audioread('received.wav');
% sound(lmao,fs);
