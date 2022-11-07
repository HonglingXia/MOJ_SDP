function [y,Single_data] = testSingle_nclasses(data,x)
test_Single_data=data;

A = [test_Single_data(:,1:9),test_Single_data(:,13)];
nbug=test_Single_data(:,10);
cost=test_Single_data(:,12);
x=x';
result=A*x(1,2:769)'+x(1,1);
pred=Logistic(result);

Single_data(:,1) = test_Single_data(:,10);%bug
Single_data(:,2) = test_Single_data(:,12);%churn
Single_data(:,3) = ifelse(pred>0.5,1,0);%pred
Single_data(:,4) = test_Single_data(:,11);%density

y(:,1)=(pred>0.5)'*cost;
y(:,2)=-(pred>0.5)'*real(nbug>0);

function Output = Logistic(Input)
Output = 1 ./ (1 + exp(-Input));
end

function Output = ifelse(a,b,c)
   Output = (a~=0)*b+(a==0)*c;
end

end