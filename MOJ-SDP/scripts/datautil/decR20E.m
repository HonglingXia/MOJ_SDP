function [y] = decR20E(data)


data = sortData(data);

len = length(data);
%%cumulative sums of LOC or NUM
cumXs  = cumsum(data(:,2)); % x: LOC% 
cumYs  = cumsum(data(:,1)); % y: Bug%

Xs = cumXs/cumXs(len);
Ys = cumYs/cumYs(len);

pos = min(find(Xs >= 0.2));
Recall_20_Effort = cumYs(pos) / cumYs(len);

y=Recall_20_Effort;
end