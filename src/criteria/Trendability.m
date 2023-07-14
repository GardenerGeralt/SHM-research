%% Trendability
function Tr = Trendability(Data,Type)
% Data : the lifetime data including lifetime variable (the lifetime
% variable must be the first column besides other features). Data should be
% in cell format.
%
% Type : the method to compute the Trendability of data including 'Corr' 'Std'

M = size(Data,2);       % Number of samples/systems
NF = size(Data{1},2)-1; % Number of features

switch Type
    case 'Corr'
        Diff = ones(2*M,NF);
        s=0;
        for j = 1 : M
            for k = 1 : M
                lifetime_j = normalize(Data{j}(:,1), 'range', [0 1]);
                lifetime_k = normalize(Data{k}(:,1), 'range', [0 1]);
                lifetime_jk = {lifetime_j , lifetime_k};
                [~,MaxIndex] = max( [numel(lifetime_j) , numel(lifetime_k)] );
                MinIndex = setdiff([1,2],MaxIndex);
                if MaxIndex == 2
                    k0=k;   k=j;   j=k0;
                end
                s = s+1;
                for i = 1 : size(Data{j},2)-1 % NF = size(Data{j},2)-1 >> Number of features
                    tsin = timeseries(Data{k}(:,i+1),lifetime_jk{MinIndex}); % reconstructing a time series for shorter signal (k index)
                    tsout = resample( tsin , lifetime_jk{MaxIndex} );        % resampling the shorter signal with respect to the longer one's lifetime
                    Diff(s,i) = abs(corr( Data{j}(:,i+1) , tsout.Data ));
                end
            end
        end
        Tr = min(Diff);
        
    otherwise
        % 'Std' based
        for j = 1 : M
            diff1 = diff(Data{j}(:,2:end));
            diff2 = diff(diff1);
            D = numel(Data{j}(:,1));
            z(j,:) = sum(diff1>0)/(D-1) + sum(diff2>0)/(D-2);
        end
        Tr = 1-std(z);
end

bar(Tr); title(['Tr (Scratch), Type: ',Type])
xlabel('Features')
ylabel('Trendability')
end