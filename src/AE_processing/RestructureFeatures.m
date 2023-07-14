clear all;
close all;

data_filename = "C:\SHM-research\output\Features\exp12_features.mat";
data = load(data_filename);
data = data.features_output{12};
nwin = height(data);

n_features = (width(data) - 1) * width(data.Amplitude{1}) * ...
    (numel(data.Amplitude{1}.mean{1}.stft{1}) * numel(data.Amplitude{1}.mean{1}.stft{1}{1}) + ...
    numel(data.Amplitude{1}.mean{1}.cwt{1}) * numel(data.Amplitude{1}.mean{1}.cwt{1}{1}));
restructd_data = cell([1, 1]);
template = zeros([nwin, n_features]);
template(:, 1) = (0:nwin-1) * 1000 + 1;
restructd_data(:) = {template};

for win = 1:nwin
    specimen_ctr = 1;
    for feature = 2:7
        for method = 1:4
            if isempty(data{win, feature}{1})
                disp("empty");
            else
                for alg = 1:2
                    alg_data = data{win, feature}{1}{1, method}{1}{1, alg}{1}(:);
                    if isempty(alg_data)
                        disp("empty");
                    else
                        for i_tile = 1:length(alg_data)
                            tile = alg_data{i_tile};
                            for i_specimen = 1:length(tile)
                                specimen = tile(i_specimen);
                                if isinf(specimen) || isnan(specimen)
%                                    disp("inf") 
                                else
                                    restructd_data{1}(win, specimen_ctr) = specimen;
        %                             disp(specimen_ctr);
                                end
                                specimen_ctr = specimen_ctr + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end


