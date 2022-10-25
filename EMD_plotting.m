function [plots] = EMD_plotting(imfs,time)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
N = length(imfs);
i = 1;
while i < N
    
    IMF{i} = imfs{i};

    
    
    tiledlayout(N,1)
    ax{i} = nexttile;
    plots = plot(ax{i},time,IMF{i});
    i = i + 1;

    
end




end