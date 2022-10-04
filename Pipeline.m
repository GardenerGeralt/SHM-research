% for file = dir('C:\SHM-research\TestData')
% data = load('C:\SHM-research\ResampledData\ByExperiment\Fs01\Exp01.mat').ResampledData;
% T = gpuArray(data.(1));
% A = gpuArray(data.(2));
makeunique_methods = {0 @mean @median @mode @max @min @sum};
len_methods = length(makeunique_methods);
size_stft = [];
size_wt = [];
size_lssp = [];

data = load('C:\SHM-research\TestData\Signals_LW1000Int1000Cycle.mat').Signals.AE_Variables;
for exp = 1:12
    disp("Exp: " + exp)
    exp_data = data{exp,1};
    nwin = height(exp_data);
    tcol = exp_data.(1);
    for var = 2:7
        disp("Var: " + var)
        var_data = exp_data.(var);
        for win = 1:nwin
            disp("Win: " + win + "/" + nwin)
            t = gpuArray(tcol{win,1});
            x = gpuArray(var_data{win,1});
            for i = 1:len_methods
                disp("Method: " + char(makeunique_methods{i}))
                if ~isa(makeunique_methods{i}, 'function_handle')
                    X = x;
                    T = t;
                else
                    [X, T] = make_unique(x, t, makeunique_methods{i});
                    [X, T] = pad_empty_cycles(X, T); % IMPORTANT: also leave unique w/o padding?
%                     [s_lssp, f_lssp] = plomb(gather(x), gather(t));
%                     size_lssp(end+1) = numel(s_lssp);
                end
                
                winlen = uint32(sqrt(length(T)/2));
                if winlen > 1
                    [s_stft, f_stft, t_stft] = stft(x, FrequencyRange="onesided", Window=hann(winlen));
                    s_stft_mag = abs(s_stft);
                    s_stft_phs = angle(s_stft);
                    % unwrappped phase here...
        
                    [s_wt, f_wt] = cwt(x);
                    s_wt_mag = abs(s_wt);
                    s_wt_phs = angle(s_wt);
    
                    size_stft(end+1) = numel(s_stft);
                    size_wt(end+1) = numel(s_wt);
                end
            end
        end
    end
end

% fig = CombinedPlot(T, (X));
% saveas(fig, "C:\SHM-research\Figures\Exp1\ResampledSignal.png");
