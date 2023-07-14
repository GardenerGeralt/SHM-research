%% Prognosability
function [Pr, x_N, Dif] = Prognosability(Data)
% Data : the lifetime data including lifetime variable (the lifetime
% variable must be the first column besides other features)
M = size(Data,2); % Number of samples/systems
NF = size(Data{1},2)-1; % Number of features
x_N = zeros(M,NF);
Dif = zeros(M,NF);
for j = 1 : M
x_N(j,:) = Data{j}(end,2:end);
Dif(j,:) = abs(Data{j}(1,2:end)-Data{j}(end,2:end));
end
Pr = exp( -std(x_N) ./ mean(Dif) );

bar(Pr); title('Pr (Scratch)')
xlabel('Features')
ylabel('Prognosability')
end