source_filename = "LW500Int500Cycle"; % didn't finish LW1000Int100Cycle Fs10
source_data = load("C:\SHM-research\TestData\Signals_" + source_filename + ".mat").Signals;
sampling_freqs = [1 5 10];
for Fs = sampling_freqs
    for exp = 1:12
        tic
        exp_data = source_data.AE_Variables{exp,1};
        nwin = length(exp_data.(1));
        ResampledData = table('Size', [nwin 7], 'VariableTypes', ...
            {'cell', 'cell', 'cell', 'cell', 'cell', 'cell', 'cell'}, 'VariableNames', ...
            {'Time (Cycle)', 'Amplitude', 'Rise-time', 'Energy', 'Counts', 'Duration', 'RMS'});
        preFs = "";        %
        if Fs < 10         %%
            preFs = "0";   %%%
        end                % adding zeros before single digits 
        preExp = "";       % for consistent file naming
        if exp < 10        %%%
            preExp = "0";  %%   
        end                %
        new_filename = "C:\SHM-research\ResampledData\ByWindow\" + source_filename + "\Fs" + preFs + Fs + "\Exp" + preExp + exp;
%         save(new_filename, "ResampledData", '-v7.3');
%         ResampledDataFile = matfile(new_filename, 'Writable', true);
%         ResampledData = ResampledDataFile.ResampledData;
        for win = 1:nwin
            t = gpuArray(exp_data.(1){win, 1});
            lent = length(t);
            if isempty(t)
                continue
            end
            for var = 2:7
                x = gpuArray(exp_data.(var){win, 1});
%                 disp("var " + var + ", win " + win + ", size " + length(x))
                if lent == 1
                    x_resampled = x;
                    t_resampled = t;
                elseif range(t) == 0
                    x_resampled = mean(x);
                    t_resampled = mean(t);
                else
%                     disp(x)
%                     disp(t)
                    [x_resampled, t_resampled] = resample(x, t, Fs);
                end
%                 reshape(ResampledData.(var)(win,1), [], length(X));
                ResampledData.(var)(win,1) = {x_resampled};
            end
%             reshape(ResampledData.(1)(win,1), [], length(T));
            ResampledData.(1)(win,1) = {t_resampled};
%         f(exp, 1) = ResampledData
            clear("t", "x", "x_resampled", "t_resampled")
        end                                              
        save(new_filename, "ResampledData", '-v7.3')
        toc
    end
end
              