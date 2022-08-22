function [time, freq, X, window] = STFT(x, win_width, win_ovrlp, varargin)
    % STFT: Short-Time Fourier Transform
    % args: amplitude, time
    %   Detailed explanation goes here
    N = length(x);
    indices = 1:N;
    w0 = 2 * pi / win_width;
    % X = x .* WINDOW(N, win_width, win_ovrlp) .* exp(-1i * freq); 
    windows = WINDOW(N, win_width, win_ovrlp);
    win_size = size(windows);
    win_nr = win_size(1);
    
    K = 1:win_width/2;
    time = 1:win_nr;
    freq = w0 * K;
    X = zeros(length(K), win_nr);
    %X = zeros(N/2, win_nr);
    for m = 1:win_nr
        window = x .* windows(m, :);
        win_indices = indices(window ~= 0);
        last_nonzero = find(window,1,'last');
        window = window(last_nonzero-win_width+1:last_nonzero);
        %Xm = fft(window);
        %Xm = Xm(1:N/2);
        %Xm_reduced = zeros(win_width/2, 1);
        for k = K
            Xmk = sum(window .* exp(-1i * freq(k) * win_indices));
            X(k, m) = Xmk;
            %Xm_reduced(k) = sum(Xm((k-1)*win_width+1:k*win_width));
        end
        
        %X(:, m) = Xm;
    end

    function [win] = WINDOW(N, width, ovrlp)
        % WINDOW: Window centered at given timestamp
        % args: number of samples, window width [samples], window overlap [samples]
        % create general window function:
        hann = (1 - cos(2 * pi * (0:width-1) / (width-1))) / 2;  % hanning window function
        hann(1) = hann(2) ;         % make first and last elements
        hann(end) = hann(end-1);    % -----> nonzero to avoid bugs
        % generate positioned windows:
        nwin = ceil(N/(width-ovrlp));   % overestimated number of windows for memory allocation
        win = zeros(nwin, N);           % array of all windows
        m_ = 1;                         % window counter
        left = 1;                       % index of first sample in window
        while left <= N-ovrlp             % loop runs until fully windowed
            right = left+width-1;         % index of last sample in window
            if right <= N                         % if full window fits on signal
                win(m_, left:right) = hann;       % place window function values
            else                                  % if window does not fit (last window)
                win(m_, end-width+1:end) = hann;  % place window with more overlap
            end
            m_ = m_+1;                    % increase window counter
            left = left+width-ovrlp;      % start of next window
        end
        win = win(any(win, 2), :);      % remove possible empty rows 
    end

end

