function [y] = decPopt(data)

data = sortData(data);

data_mdl = data;
data_opt = sortrows(sortrows(data,2),-4);
%data_opt = data[order(-data$density, +data$LOC), ]
data_wst = sortrows(sortrows(data,-2),4);
%data_wst <- data[order(+data$density, -data$LOC), ]

area_mdl = decArea(data_mdl);
area_opt = decArea(data_opt);
area_wst = decArea(data_wst);

Popt = 1 - (area_opt - area_mdl)/(area_opt - area_wst);

y = Popt;
end