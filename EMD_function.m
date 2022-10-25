function [imfs,residual] = EMD_function(data,t,stop_method)
[data_preprocessed,t_preprocessed] = EMD_preprocessing(data,t);

continue_emd = true;
proto = data_preprocessed;
imf_storage = {};

while continue_emd
     [IMF_j,npeaks] = IMF_sift(proto, t_preprocessed,stop_method);
     proto = proto - IMF_j;
     imf_storage{end+1} = IMF_j;
     

    STOP_EMD = (npeaks < 2) ; %If number of peaks in IMF is below this number, the algorithm stops
    [~,Energy_ratio] = energy_difference(data,IMF_j)
    if STOP_EMD
        imfs = imf_storage;
        continue_emd = false;
   
    
    

  
    


    
    end

end 
