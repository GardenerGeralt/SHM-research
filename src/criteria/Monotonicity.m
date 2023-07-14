%% Monotonicity
function Mo = Monotonicity(Data,Type)
% Data : the lifetime data including lifetime variable (the lifetime
% variable must be the first column besides other features)
% Type : the method to compute the Monotonicity of data including 'MK',
% 'MMK', 'Signum', 'Rank'

M = size(Data,2); % Number of samples/systems
NF = size(Data{1},2)-1; % Number of features
N = zeros(1,M);
Mo_Sample = zeros(M,NF);
for j = 1 : M
    N(j) = size(Data{j},1); % Number of measurements on the jth system
    Mo_Sample_time = zeros(N(j)-1,size(Data{j},2)-1); % NF = size(Data{j},2)-1 >> Number of features
    switch Type
        case {'MK','Mann-Kendall'}
            for i = 1 : N(j)
                Mo0 = zeros(N(j)-i,NF);
               for k = i+1 : N(j)
                   Mo0(k-i,:) = (Data{j}(k,1)-Data{j}(i,1)) * sign(Data{j}(k,2:end)-Data{j}(i,2:end));
               end
               Mo_Sample_time(i,:) = sum(Mo0); % Monotonicity for one sample, one time increament
            end
            Mo_Sample(j,:) = abs(sum(Mo_Sample_time)); % Monotonicity for one sample, entire lifetime
            
        case {'MMK','Modified-Mann-Kendall'}
            for i = 1 : N(j)-1
%                 numerator_Mo0 = zeros(N(j)-i,NF);
%                 denominator_Mo0 = zeros(N(j)-i,1);
               for k = i+1 : N(j)
                   numerator_Mo0(k-i,:) = (Data{j}(k,1)-Data{j}(i,1)) * sign(Data{j}(k,2:end)-Data{j}(i,2:end));
                   denominator_Mo0(k-i,1) = Data{j}(k,1)-Data{j}(i,1);
               end
               Mo_Sample_time(i,:) = sum(numerator_Mo0)/sum(denominator_Mo0); % Monotonicity for one sample, one time increament
            end
            Mo_Sample(j,:) = abs(sum(Mo_Sample_time))/(N(j)-1); % Monotonicity for one sample, entire lifetime
            
        case {'Rank','Spearman','Spearman-Rank'}
            Mo_Sample(j,:) = abs(corr( (Data{j}(:,2:end)) , (Data{j}(:,1)) ));
            %             Mo_Sample(j,:) = abs(corr( rank(Data{j}(:,2:end)) , rank(Data{j}(:,1)) ));

        otherwise % 'Signum' , 'Sign'
            for k = 1:N(j)-1
                Mo_Sample_time(k,:) = sign( Data{j}(k+1,2:end)-Data{j}(k,2:end) ); % Monotonicity for one sample, one time increament
            end
            Mo_Sample(j,:) = abs(sum(Mo_Sample_time)) / (N(j)-1); % Monotonicity for one sample, entire lifetime
    end
%     bar(Mo_Sample(j,:)); title('Skratch - one sample')
end
Mo = sum(Mo_Sample)/M; % Monotonicity for all samples, entire lifetime
bar(Mo); title(['Mo (Scratch), Type: ',Type])
xlabel('Features')
ylabel('Monotonicity')
end