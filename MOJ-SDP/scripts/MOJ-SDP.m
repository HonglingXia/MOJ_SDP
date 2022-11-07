%%%%%%利用十折交叉验证，同项目多目标优化，
addpath('datautil')
addpath('MODEP')
addpath('WithinProject')
load fisheriris
%features-train-muti'commons-lang''commons-math''opennlp''commons-beanutils''commons-becl''commons-codec''commons-collections''commons-compress''commons-configuration''commons-dbcp''commons-digester''commons-gora''commons-io''commons-jcs''commons-net''commons-scxml''commons-validator''commons-vfx''giraph''parquet-mr'
train_projects = {'features-train-muti'};
test_projects = {'features-test-muti'};
%train_projects = {'commons-lang-train'};
%test_projects = {'commons-lang-test'};
%projects = {'bugzilla','columba','jdt', 'platform' ,'mozilla', 'postgres'};
for i=1:1:length(train_projects)
    project_train=train_projects{i};
    disp(project_train);
    
    project_test=test_projects{i};
    disp(project_test);
    
    train_data = csvread(['..//dataset_train//',project_train,'.csv'],1);
    test_data = csvread(['..//dataset_test//',project_test,'.csv'],1);
    
    %-----------------------------------------------------------------------
    Recall_Churn=zeros(50,2);
    project_P_A = [1:991]';
    indices = crossvalind('Kfold',length(train_data),10);
   %for m = 1:10
        %wp_popt_acc=[m,m,m,m,m,m];
        %disp(m);
        wp_popt_acc=[1,1,1,1,1,1];
        %disp(1);
        %for i = 1:10
              %disp(m*10+i);
              %test = (indices == i); 
              %train = ~test;    %分别取第1、2、...、10份为测试集，其余为训练集
              data_train=train_data;
              data_test=test_data;

             % data_train = doSampling(data_train,14);%消除类不平衡问题
              %data_test = doSampling(data_test,14);
              %data_train = datapreprocessing(data_train);
              %data_test = datapreprocessing(data_test);

              save('training_data.mat','data_train','-mat');
              save('testing_data.mat','data_test','-mat');
            for j = 1:10
              [X,FVAL,POPULATION,SCORE,OUTPUT]=MODEP('logistic','nclasses');

              [y,popt_acc] = testLogistic_nclasses(X);
              wp_popt_acc = [wp_popt_acc;popt_acc];
            end
        %end
        project_P_A = [project_P_A,wp_popt_acc;];
   % end
    csvwrite(['..//dataoutput_cv//',project_train,'.csv'],project_P_A);
end
clear max;
clear median;
clear result;
max = max(project_P_A(2:end,2:end));
median = median(project_P_A(2:end,2:end));

popt_max_sum = 0;
acc_max_sum = 0;
f1_max_sum = 0;
auc_max_sum = 0;
r20e_max_sum = 0;
e20r_min_sum = 0;
popt_median_sum = 0;
acc_median_sum = 0;
f1_median_sum = 0;
auc_median_sum = 0;
r20e_median_sum = 0;
e20r_median_sum = 0;

for i=1:6:length(max)
    popt_max_sum = popt_max_sum + max(i);
    acc_max_sum = acc_max_sum + max(i+1);
    f1_max_sum = f1_max_sum + max(i+2);
    auc_max_sum = auc_max_sum + max(i+3);
    r20e_max_sum = r20e_max_sum + max(i+4);
    e20r_min_sum = e20r_min_sum + min(i+5);
end
for i=1:6:length(median)
    popt_median_sum = popt_median_sum + median(i);
    acc_median_sum = acc_median_sum + median(i+1);
    f1_median_sum = f1_median_sum + median(i+2);
    auc_median_sum = auc_median_sum + median(i+3);
    r20e_median_sum = r20e_median_sum + median(i+4);
    e20r_median_sum = e20r_median_sum + median(i+5);
end
popt_max = [{'popt_max'}; num2cell(popt_max_sum)];
acc_max = [{'acc_max'}; num2cell(acc_max_sum)];
f1_max = [{'f1_max'}; num2cell(f1_max_sum)];
auc_max = [{'auc_max'}; num2cell(auc_max_sum)];
r20e_max = [{'r20e_max'}; num2cell(r20e_max_sum)];
e20r_min = [{'e20r_min'}; num2cell(e20r_min_sum)];
popt_median = [{'popt_median'}; num2cell(popt_median_sum)];
acc_median = [{'acc_median'}; num2cell(acc_median_sum)];
f1_median = [{'f1_median'}; num2cell(f1_median_sum)];
auc_median = [{'auc_median'}; num2cell(auc_median_sum)];
r20e_median = [{'r20e_median'}; num2cell(r20e_median_sum)];
e20r_median = [{'e20r_median'}; num2cell(e20r_median_sum)];

result = cat(2,popt_max,popt_median,acc_max,acc_median,f1_max,f1_median,auc_max,auc_median,r20e_max,r20e_median,e20r_min,e20r_median);
xlswrite(['..//dataoutput_pa//',project_train,'传统.xlsx'],result);
