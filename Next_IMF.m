function [Next_IMF,npeaks] = Next_IMF(Previous_IMF,data,time)
new_data  = data - Previous_IMF;
[Next_IMF,npeaks] = IMF_sift(new_data,time);




end