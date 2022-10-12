data = load('C:\SHM-research\TestData\Signals_LW100Int100Cycle.mat').Signals;
SamplingFreqs = 10;
for Fs = SamplingFreqs
%     f = table('Size', [12, 1], 'VariableTypes', {'table'}, 'VariableNames', {'Experiment'});
    for exp = 1:12
        tic
        t = gpuArray(cat(1, data.AE_Variables{exp,1}.(1){:, 1}));
        for var = 2:7
            x = gpuArray(cat(1, data.AE_Variables{exp,1}.(var){:, 1}));
            [X, T] = resample(x, t, Fs);
            if var == 2
                ResampledData = table('Size', [length(T) 7], 'VariableTypes', ...
                    {'double', 'double', 'double', 'double', 'double', 'double', 'double'}, 'VariableNames', ...
                    {'Time (Cycle)', 'Amplitude', 'Rise-time', 'Energy', 'Counts', 'Duration', 'RMS'});
            end
            ResampledData(:, var) = array2table(X);
        end
        ResampledData(:, 1) = array2table(T);
%         f(exp, 1) = ResampledData;
        save("C:\SHM-research\ResampledData\ByExperiment\Fs" + Fs + "\Exp0" + exp, "ResampledData")
        toc
    end
end
                
