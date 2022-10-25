function [STOP_SD] = SD_stopmethod(data,res)

STOP_SD = sum((data - res).^2) / sum(data.^2);
end