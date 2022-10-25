function [IMF_i,npeaks] = IMF_sift(data_input,time,stop_method)

proto_imf = data_input;
Continue_sift = true; 

while Continue_sift
    [pksmax,locmax] = findpeaks(proto_imf);
    [pksmin,locmin] = findpeaks(-proto_imf);
    pksmin = -pksmin;
    locations_minima = time(locmin);
    locations_maxima = time(locmax);
    npeaks_i = length(pksmin) + length(pksmax);
    length_pksmin = length(pksmin) < 2;
    length_pksmax = length(pksmax) < 2 ;
    if length_pksmax || length_pksmin 
        IMF_i = proto_imf;
        npeaks = npeaks_i;
        Continue_sift = false;
        break
    end

    %Upper/Lower envelopes + mean
    xq = linspace(time(1),time(end),length(time));
    E_up = pchip(locations_maxima,pksmax,xq);
    E_low = pchip(locations_minima,pksmin,xq);
   
    E_mean = transpose(((E_low + E_up) / 2)); %MEAN of upper/lower envelope
    %
    x1 = proto_imf - E_mean ;   

    %Sifting STOP methods
    if stop_method == "SD_stopmethod"
        stop_value = SD_stopmethod(x1,proto_imf);
        STOP = stop_value < 0.2;
    elseif stop_method == "energy_difference"
        [stop_value,~,~] = energy_difference(proto_imf,x1); 
        STOP = stop_value < 0.1;
    end


    if STOP
        IMF_i = proto_imf;
        Continue_sift = false;
        npeaks = npeaks_i;
    end

    proto_imf = proto_imf - E_mean;




end






