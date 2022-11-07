function [ y,WP_POPT_ACC ] = testLogistic_nclasses(x)

% training_bugzilla_fit = csvread('training_bugzilla_fit_1.csv');
% save('training_bugzilla_fit.mat','training_bugzilla_fit','-mat');

%test_data = csvread(['..//dataset//test_',project,'.csv']);
%save(['test_',project,'_fit.mat'],'test_data','-mat');
test_data=importdata('testing_data.mat');
%test_data=importdata('training_bugzilla_fit.mat');

lt = test_data(:,8).*test_data(:,3);
lt(lt==0) = lt(lt==0) +1;
churn = ((test_data(:,1) + test_data(:,2)).* lt)/2;

churn_p = log2(churn+1);
test_data(:,[1,2,6:13]) = test_data(:,[1,2,6:13])+1;
test_data(:,1:13) = log(test_data(:,1:13));
test_data(:,15:782) = log(test_data(:,15:782));
A = [test_data(:,4),test_data(:,3),test_data(:,6),lt,test_data(:,7),test_data(:,10),test_data(:,9),test_data(:,11),test_data(:,13),churn_p,test_data(:,15:end)];
%A = test_data(:,15:782);
nbug=test_data(:,14);
cost=churn;
y=zeros(10,2);
for i = 1:1:size(x,1)-1
    result=A*x(i,2:779)'+x(i,1);%769
    pred=Logistic(result);
    %for j = 1:1:size(pred)
      %  if pred(j)>0.5
      %      pred(j)=1;
      %  else
      %      pred(j)=0;
     %   end
   % end
    WPdata(:,1) = test_data(:,14);%bug
    WPdata(:,2) = churn;%churn
    WPdata(:,3) = ifelse(pred>0.5,1,0);%ifelse(pred>0.5,1,0);%pred
    WPdata(:,4) = WPdata(:,1)./(WPdata(:,2)+1);%density
    WP_POPT_ACC(i,1) = decPopt(WPdata);
    
    WP_POPT_ACC(i,2) = decACC(WPdata);
    WP_POPT_ACC(i,3) = decF1(WPdata);
    WP_POPT_ACC(i,4) = decAuc(WPdata);
    WP_POPT_ACC(i,5) = decR20E(WPdata);
    WP_POPT_ACC(i,6) = decE20R(WPdata);
    y(i,1)=(pred>0.5)'*cost;
    y(i,2)=-(pred>0.5)'*real(nbug>0);
end

function Output = Logistic(Input)
Output = 1 ./ (1 + exp(-Input));
end
function Output = ifelse(a,b,c)
   Output = (a~=0)*b+(a==0)*c;
end
end