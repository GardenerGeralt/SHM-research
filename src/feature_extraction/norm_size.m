function [norm_data] = norm_size(input_data, norm_len)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    if length(input_data) == 2
        input_f = input_data{1};
        input_s = input_data{2};
        
        norm_f = linspace(input_f(1), input_f(end), norm_len);
        norm_s = interp1(input_f, input_s, norm_f, "spline");

        norm_data = {norm_f, norm_s};
    elseif length(input_data) == 3
        input_t = input_data{1};
        input_f = input_data{2};
        input_s = input_data{3};

        side_len = sqrt(norm_len);
        norm_t = linspace(input_t(1), input_t(end), side_len);
        norm_f = linspace(input_f(1), input_f(end), side_len);
        norm_s = interp2(input_t, input_f, input_s, norm_t, norm_f);

        norm_data = {norm_t, norm_f, norm_s};
    end
end