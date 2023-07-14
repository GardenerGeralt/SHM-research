% function Fitness0 = MTP_Scratch(Data,a,b,c,Type)
function Fitness0 = MTP_Scratch(varargin)
%% Scratch
% Data: the lifetime data including lifetime variable (the lifetime variable must be the first column besides other features)
%% Preparation of inputs
Data = varargin{1}; 
if nargin  > 1
    a = varargin{2};
else
    a = 1;
end

if nargin  > 2
    b = varargin{3};
else
    b = 1;
end

if nargin  > 3
    c = varargin{4};
else
    c = 1;
end

if nargin  > 4
    Type = varargin{5};
else
    Type = {'MMK';'Corr'};
end

%% Applying Criteria
f = figure('visible','on');
subplot(3,1,1)
Mo = Monotonicity(Data, Type{1});
% Type(2nd input) of Mo: 'MK', 'MMK', 'Sign', 'Rank'
% xticklabels(Names(2:end))
if strcmp(Type{1},{'MK','Mann-Kendall'})==0
    ylim([0 1])
end

subplot(3,1,2)
Tr = Trendability(Data, Type{2});
% Type(2nd input) of Tr: 'Corr' 'Std'
% xticklabels(Names(2:end))
ylim([0 1])

subplot(3,1,3)
Pr = Prognosability(Data);
% xticklabels(Names(2:end))
ylim([0 1])
Crit = [Mo;Tr;Pr];
Crit = fillmissing(Crit,'constant',0);
Fitness0 = a*Crit(1,:) + b*Crit(2,:) + c*Crit(3,:);
saveas(f,'MTP.pdf')
end