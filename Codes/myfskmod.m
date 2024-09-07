function y = myfskmod(x, M, freq_sep,df,fc, Fs)
    % x          - Input signal (vector of integers)
    % M          - Number of frequency shifts (M-ary)
    % freq_sep   - Frequency separation
    % Fs         - Sampling frequency
    % init_phase - Initial phase of the modulated signal

    % Length of the input signal
    n = length(x);
    
    % Duration of one symbol (in seconds)
    symbol_duration = log2(M)* freq_sep;
    
    % Number of samples per symbol
    samples_per_symbol = 297;
    
    % Time vector for one symbol
    t = (0:samples_per_symbol-1)'/Fs;
    
    % Initialize output signal
    y = zeros(samples_per_symbol*n, 1);
    
    % Modulate each symbol
    for i = 0:n-1
        % Frequency for the current symbol
        freq = fc+x(i+1)*df;
        
        % Modulated signal for the current symbol
        y(i*samples_per_symbol + (1:samples_per_symbol)) = cos(2 * pi * freq * t);
    end
end
