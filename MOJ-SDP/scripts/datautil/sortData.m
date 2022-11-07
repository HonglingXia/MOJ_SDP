function [y] = sortData(data)

%density = data(:,1)./(data(:,2)+1);%º∆À„√‹∂»
%data = [data,density];
data = sortrows(data,-3);

y =data;

end