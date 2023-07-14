% clear all;
% close all;

load('C:\SHM-research\TestData\LW_Data\LW_data.mat')

all_features = cell([1, 12]);
for L = 1 : length(Layups) % index of layup
    for S = 1 : length(Layups{L, 1}.Specimen) % index of specimen
        specimen_features = zeros([length(Layups{L, 1}.Specimen{S, 1}.Input), 342]);
        pulses = 1:height(specimen_features);
        specimen_features = cat(2, pulses.', specimen_features);
        for t = 1 : length(Layups{L, 1}.Specimen{S, 1}.Input) % index of time step
            disp("Layup " + L + ", Specimen " + S + ", Timestep " + t + "/" + length(Layups{L, 1}.Specimen{S, 1}.Input))
            for fr = 150 % [150 200 250 300 350 400 450] % index of frequency
                signal_length = length(Layups{L, 1}.Specimen{S, 1}.Input{t, 1}.Raw.("fr"+string(fr)).("P"+string(1))(2,:));
                winlen = uint32(4 * sqrt(signal_length/2)); % window length for STFT
                path_features = zeros([342, 36]);
%                 figure;
                for p = 1 : 36 % index of path
                    ss = Layups{L, 1}.Specimen{S, 1}.Input{t, 1}.Raw.("fr"+string(fr)).("P"+string(p))(2,:); % sensor signal
%                     plot(1:2000,ss,'DisplayName',"P"+p);hold on;

                    [s_stft, f_stft, t_stft] = stft(ss, 1, FrequencyRange="onesided", Window=hann(winlen));
                    s_stft_mag =  resample(abs(s_stft), height(s_stft), width(s_stft), 'Dimension', 2); % to make the spectrogram square
                    stft_features = TF_features(complex(s_stft_mag));
%                     stft(ss, 1, FrequencyRange="onesided", Window=hann(winlen))
                    
                    [s_wt, f_wt] = cwt(ss, TimeBandwidth=12);
                    s_wt_mag =  resample(abs(s_wt), height(s_wt), width(s_wt), 'Dimension', 2); % to make the scalogram square
                    wt_features = TF_features(complex(s_wt_mag));
                    cwt(ss, TimeBandwidth=12)


                    joined_features = cat(1, stft_features{:}, wt_features{:});
                    path_features(:, p) = joined_features;
                end
                path_averaged_features = mean(path_features, 2).';
%                 hold off;
            end
            specimen_features(t, 2:end) = path_averaged_features;
        end
        all_features((L-1)*3 + S) = {specimen_features};
    end
end