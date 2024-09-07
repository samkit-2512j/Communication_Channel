function [bitarr,fs] = antodig(audio_file)
[audio, fs] = audioread(audio_file); % Load your audio file here
audio_normalized = int16(audio * 32767); % Normalize
audio_binary = dec2bin(typecast(audio_normalized(:), 'uint16'), 16); % Convert to binary
audio_binary = audio_binary(:)'; % Reshape to vector for transmission
bitarr=zeros(1,length(audio_binary));
for n=1:length(audio_binary)
    bitarr(n)=double(audio_binary(n))-double('0');
end
bitarr=bitarr';
end

