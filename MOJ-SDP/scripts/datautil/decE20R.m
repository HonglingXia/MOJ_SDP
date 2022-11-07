function [y] = decE20R(data)

%data(:,4) = abs(data(:,4));
%data = sortrows(data,-4);
%buggy_length = data(data(:,1)==1&data(:,4)>0);
%cum_loc = cumsum(data(:,5));
%buggy_20_length = floor(0.2 * length(buggy_length));
%buggy_20_loc = sum(data(1:buggy_20_length,5));
%Effort_20_Recall = buggy_20_loc / cum_loc(end);


data = sortData(data);

len = length(data);
%%cumulative sums of LOC or NUM
cumXs  = cumsum(data(:,2)); % x: LOC% 
cumYs  = cumsum(data(:,1)); % y: Bug%

Xs = cumXs/cumXs(len);
Ys = cumYs/cumYs(len);

pos = min(find(Ys >= 0.2));
Effort_20_Recall = cumXs(pos) / cumXs(len);

y=Effort_20_Recall;
end