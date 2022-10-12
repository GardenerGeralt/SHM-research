function [X] = WT(x)
    % WT: Wavelet Transform
    N = length(x);
    X = zeros(log2(N), N);
    a = 1;
    depth = 1;
    while depth < log2(N)
        B = 1 - flip(1:1/a) * a;
        % depth = 1+log2(1/a);
        for b = B
            box = (N*b+1):(N*(b+a));
            wav = WAVELET(a, b);
            X(depth, box) = sum(wav .* x) / sqrt(a);
        end
        a = a / 2;
        depth = depth + 1;
    end
    function [W] = WAVELET(a, b)
        % WAVELET: Haar wavelet 
        wav_scale = N*a;    % number of samples in wavelet
        time_shift = N*b;   % number of samples before wavelet
        W = cat(2, zeros(1, time_shift), ones(1, wav_scale/2), ...
            -ones(1, wav_scale/2), zeros(1, N - wav_scale - time_shift));
    end
end

