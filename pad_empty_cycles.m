function [x_padded, t_padded] = pad_empty_cycles(x, t)
% pad_empty_cells: fill cycles that have no recorded hits with null values
   
%     t = gpuArray(t);
%     x = gpuArray(x);
    if all(unique(t) == t)
        t_padded = t(1):t(end);
        x_padded = zeros(size(t));
        x_padded(ismember(t_padded, t)) = x;
    else
        disp('invalid')
%         gaps = [0 find( (t(2:end) - t(1:end-1)) > 1 )];
%         x_padded = [];
%         for igap = 2:length(gaps)
%             current_gap = gaps(igap);
%             prev_gap = gaps(igap-1);
%             x_padded = [x_padded x((prev_gap+1):current_gap) x(current_gap)+1:x(current_gap+1)];
%     
%         t_padded = t(1):t(end);
%     
%         x_padded(t_padded == ) = 
%         end

    end
end