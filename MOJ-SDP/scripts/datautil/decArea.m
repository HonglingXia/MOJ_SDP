function [y] = decArea(data)

%data = sortData(data);

len = length(data);
% cumulative sums of LOC or NUM
cumXs  = cumsum(data(:,2)); % x: LOC%
cumYs  = cumsum(data(:,1)); % y: Bug%

Xs = cumXs/cumXs(len);
Ys = cumYs/cumYs(len);

fix_subareas = ones(1,len);
fix_subareas(:,1) = 0.5 * Ys(1,:) * Xs(1,:);
fix_subareas(2:len) = 0.5 .* (Ys(1:(len-1),:) + Ys(2:len,:)) .* abs(Xs(1:(len-1),:) - Xs(2:len,:));

area = sum(fix_subareas);
y = area;
end