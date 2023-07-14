clear all;
close all;

data_file_name = "C:\SHM-research\TestData\AE_Data\Signals_LW1000Int1000Cycle.mat";

Fs = 1.0;

default_nwin = split(data_file_name, {'LW', 'Int'});
default_nwin = str2double(default_nwin{2});
norm_len = round(sqrt(default_nwin)) ^ 2;

makeunique_methods = {@mean @max @min @sum};
len_methods = length(makeunique_methods);
% size_stft = [];
% size_wt = [];
% size_lssp = [];

data = load(data_file_name).Signals.AE_Variables;
features_output = cell([12 1]) ;
for exp = 12
    disp("Exp: " + exp)
    exp_data = data{exp,1};
    nwin = height(exp_data);
    tcol = exp_data.(1);
    features_exp = table('Size', [nwin 7] , 'VariableTypes', ["double", "cell", "cell", "cell", "cell", "cell", "cell"], ...
        'VariableNames', ["Time (Cycle)", "Amplitude", "Rise-time", "Energy", "Counts", "Duration", "RMS"]);
    features_exp{:, "Time (Cycle)"} = transpose(1:nwin);
    for var = 2:7
        disp("Var: " + var)
        var_data = exp_data.(var);
        for win = 1:nwin
            disp("Exp:" + exp + ", Var:" + var + ", Win: " + win + "/" + nwin)
            t = gpuArray(tcol{win,1});
            x = gpuArray(var_data{win,1});
            if isempty(t)
                continue
            end
            features_var_win = table('Size', [1 4] , 'VariableTypes', ["cell", "cell", "cell", "cell"], ...
                'VariableNames', ["mean", " max", "min", "sum"]);
            for method_number = 1:len_methods
                features_mumethod = table('Size', [1 2] , 'VariableTypes', ["cell", "cell"], ...
                'VariableNames', ["stft", "cwt"]);
%                 disp("Method: " + char(makeunique_methods{method_number}))
                if ~isa(makeunique_methods{method_number}, 'function_handle')
                    X = x;
                    T = t;
                else
                    [X, T] = make_unique(x, t, makeunique_methods{method_number});
                    [X, T] = pad_empty_cycles(X, T, 1000); % IMPORTANT: also leave unique w/o padding?
%                     [s_lssp, f_lssp] = plomb(gather(x), gather(t));
%                     size_lssp(end+1) = numel(s_lssp);
                end
                
                winlen = uint32(4 * sqrt(length(T)/2));
                if winlen > 1
                    [s_stft, f_stft, t_stft] = stft(X, Fs, FrequencyRange="onesided", Window=hann(winlen));
                    s_stft_mag =  resample(abs(s_stft), height(s_stft), width(s_stft), 'Dimension', 2);
%                     s_stft_phs = angle(s_stft);
                    features_mumethod{1,"stft"} = {TF_features(complex(s_stft_mag))};
                    
                    [s_wt, f_wt] = cwt(X, TimeBandwidth=12);
                    s_wt_mag =  resample(abs(s_wt), height(s_wt), width(s_wt), 'Dimension', 2);
%                     s_wt_phs = angle(s_wt);
                    features_mumethod{1,"cwt"} = {TF_features(complex(s_wt_mag))};

%                     t_aslt = T;
%                     f_aslt = linspace(1e-6, Fs/2, winlen);
%                     s_aslt = faslt(X, Fs, f_aslt, 1, [1, 5], 0);
%                     features_mumethod.aslt = TF_features(complex(s_aslt));
                end
                features_var_win{1, method_number} = {features_mumethod};
            end
            features_exp{win, var} = {features_var_win};
        end
    end
    features_output{exp} = features_exp;
end

% fig = CombinedPlot(T, (X));
% saveas(fig, "C:\SHM-research\Figures\Exp1\ResampledSignal.png");
