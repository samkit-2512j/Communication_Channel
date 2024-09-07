function x = myfskdemod(y, M, freq_sep,df,fc, Fs)
    % y          - Received modulated signal
    % M          - Number of frequency shifts (M-ary)
    % freq_sep   - Frequency separation
    % Fs         - Sampling frequency
    % init_phase - Initial phase of the modulated signal

    % Duration of one symbol (in seconds)
    symbol_duration = log2(M)*freq_sep;
    
    % Number of samples per symbol
    samples_per_symbol = 297;
    
    % Length of the input signal
    n = length(y);
    
    % Number of symbols in the input signal
    num_symbols = n / samples_per_symbol;
    
    % Time vector for one symbol
    t = (0:samples_per_symbol-1)'/Fs;
    
    % Initialize output symbols vector
    x = zeros(num_symbols, 1);
    
    % Demodulate each symbol
    for i = 0:num_symbols-1
        % Extract the current symbol from the modulated signal
        current_symbol = y(i*samples_per_symbol + (1:samples_per_symbol));
        
        % Initialize a vector to store correlation values
        correlation = zeros(M, 1);
        
        % Compare against all possible frequencies
        for k = 1:M
            % Frequency of the k-th symbol
            freq = fc+(k-1)*df;
            
            % Generate the reference cosine wave for the k-th frequency
            reference_signal = cos(2 * pi * freq * t);
            
            % Compute the correlation (dot product) between the current symbol and reference
            correlation(k) = sum(current_symbol .* reference_signal);
        end
        
        % Determine which frequency had the highest correlation
        [~, max_index] = max(correlation);
        
        % Assign the decoded symbol
        x(i+1) = max_index-1;
    end
end
