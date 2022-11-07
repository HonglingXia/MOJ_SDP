function [ y ] = fitnessLogistic_nclasses(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

traing_data=importdata('training_data.mat');
lt = traing_data(:,8).*traing_data(:,3);
lt(lt==0) = lt(lt==0) +1;
churn = ((traing_data(:,1) + traing_data(:,2)).* lt)/2;

churn_p = log2(churn+1);
traing_data(:,[1,2,6:13]) = traing_data(:,[1,2,6:13])+1;
traing_data(:,1:13) = log(traing_data(:,1:13));
traing_data(:,15:782) = log(traing_data(:,15:782));
A = [traing_data(:,4),traing_data(:,3),traing_data(:,6),lt,traing_data(:,7),traing_data(:,10),traing_data(:,9),traing_data(:,11),traing_data(:,13),churn_p,traing_data(:,15:782)];
%A = traing_data(:,15:782);
%A = [traing_data(:,1:9),traing_data(:,13)];
nbug=traing_data(:,14);
cost=churn;
result=A*x(:,2:779)'+repmat(x(:,1)',length(A(:,1)),1);%x的所有行第一列  length(A(:,1))行1列 769
pred=Logistic(result);
y(:,1)=(pred>0.5)'*cost;
y(:,2)=-(pred>0.5)'*real(nbug>0);%real(nbug>0) nbug是否大于0 返回1是0否

function Output = Logistic(Input)
Output = 1 ./ (1 + exp(-Input));
end
end


