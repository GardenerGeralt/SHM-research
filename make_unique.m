function [x_unique, t_unique] = make_unique(x, t, method)
% make_unique: convert to a signal with only one datapoint per cycle
% Where overlapping datapoints are found, a single 
%       summarizing value is obtained using method.
    [t_unique, i_repeated, ~] = unique(t);
    x_unique = gpuArray(zeros(size(t_unique)));
    
    t_repeated = t(i_repeated);
    for i = 1:length(t_unique)
        t_samp = t_unique(i);
        if any(t_samp == t_repeated)
            x_unique(i) = method(x(t==t_samp));
        else
            x_unique(i) = x(t==t_samp);
        end
    end
end