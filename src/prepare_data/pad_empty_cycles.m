function [x_padded, t_padded] = pad_empty_cycles(x, t, win_len)
% pad_empty_cells: fill cycles that have no recorded hits with null values
   
%     t = gpuArray(t);
%     x = gpuArray(x);
    if all(unique(t) == t)
        numwin = double(idivide(t(1), int16(win_len)));
        t_padded = (1:win_len) + numwin*win_len;  % t(1):t(end);
        x_padded = zeros(size(t_padded));
        x_padded(ismember(t_padded, t)) = x;
%         t_padded = gpuArray(t_padded);
%         x_padded = gpuArray(x_padded);
    else
        disp('invalid')
    end
end