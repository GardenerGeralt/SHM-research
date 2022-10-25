function [Energy_Diference,Energy_ratio] = energy_difference(imf,residual)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sum_imf = sum(imf.^2);
imf_energy = 20 * log10(sum_imf);
sum_residual = sum(residual.^2);
residual_energy = 20* log10(sum_residual);
Energy_Diference = imf_energy - residual_energy;
Energy_ratio = 10 * log10(sum_imf / sum_residual);
end