function [x_preprocessed,t_preprocessed] = EMD_preprocessing(data,time)
        [clean_data,t_clean] = make_unique(data,time,@mean);
        [x_padded,t_padded] = pad_empty_cycles(clean_data,t_clean);
        x_preprocessed = x_padded;
        t_preprocessed = t_padded;
       
    end