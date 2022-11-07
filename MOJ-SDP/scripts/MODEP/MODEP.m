function [X,FVAL,POPULATION,SCORE,OUTPUT]=MODEP(model,prediction_type)
% MODE.m, Version 1.0
% MODEP implements the multi-objective defect prediciton models
%
% Input arguments: 
%
%   model, can be one of the two prediciton model 'logistic' and 'detree'.
%   When model='logistic', a logistic regression model will be used to
%   create a multi-objective prediction models. If model='dtree', the MODEP
%   will use decision trees (implemented by the classeregtree routines)
%
%   prediction_type, is used to specify which measure of effectiveness has 
%   to be used. When prediction_type='nclasses' MODEP will consider the
%   number of predicting classes as second fitness function to optimize
%   (maximize). When prediction_type='ndefects' MODEP will consider the
%   total number of defects as second fitness function to optimize
%   (maximize). 
%
% Output values: 
%   
%   X is the set of non-dominated solutions (set of optimal prediction
%   models.
%
%   FVAL is the set of fitness values of X  
%
%   POPULATION is the final population obtained by GAs 
%
%   SCORE is the set of fitness values of POPULATION 
%
%   OUTPUT is a structure that contains output from each generation and other
%   information about the performance of the algorithm
%
% Examples: 
%
%   [X,FVAL,POPULATION,SCORE,OUTPUT]=MODEP('logistic','nclasses')
%
% ----------- Set Defaults for Input Parameters and Options -------------
% These defaults may be edited for convenience

% Input Defaults (obsolete, these are obligatory now)
warning('off','globaloptim:constrvalidate:unconstrainedMutationFcn');
options = gaoptimset(@gamultiobj);
PopulationSize=200;
if (strcmpi(prediction_type,'nclasses'))
    if (strcmpi(model,'logistic'))
        %apply logistic regression model
        nvar=779;
        options= gaoptimset(options,'PopulationSize',PopulationSize,'PopInitRange',[-10;10],'Generations',400,'UseParallel','always','Vectorized','on','CrossoverFcn',{@crossoverarithmetic},'CrossoverFraction',0.5,'TolFun',10^(-10),'MigrationDirection','both','InitialPopulation',[],'MutationFcn',{@mutationuniform,1/nvar},'DistanceMeasureFcn',{@distancecrowding, 'phenotype'},'ParetoFraction',0.5,'Display','off','PlotFcns',{@gaplotpareto});
        [X,FVAL,~,OUTPUT,POPULATION,SCORE] = gamultiobj(@fitnessLogistic_nclasses,nvar,[],[],[],[],-100*ones(1,nvar),100*ones(1,nvar),options);
        %X
    elseif (strcmpi(model,'dtree'))
        %compute the structure of decision tree
        A=importdata('training.mat');
        b=importdata('nbug_training.mat');b=b>0;
        t=classregtree(A,b);
        save('tree.mat','t','-mat')
        %identify the number of decision nodes
        nvar=sum(~isnan(cutpoint(t)));
        %runGA
        options= gaoptimset(options,'PopulationSize',PopulationSize,'PopInitRange',[-10;10],'Generations',100,'UseParallel','always','CrossoverFcn',{@crossoverarithmetic},'CrossoverFraction',0.5,'TolFun',10^(-10),'MigrationDirection','both','InitialPopulation',[],'MutationFcn',{@mutationuniform,1/nvar},'DistanceMeasureFcn',{@distancecrowding, 'phenotype'},'ParetoFraction',0.5,'Display','off','PlotFcns',{@gaplotpareto});
        [X,FVAL,~,OUTPUT,POPULATION,SCORE] = gamultiobj(@fitnessTree_nclasses,nvar,[],[],[],[],-100*ones(1,nvar),100*ones(1,nvar),options);
    else
        warning('Undefined Prediction Model');
    end
elseif (strcmpi(prediction_type,'ndefects'))
    if (strcmpi(model,'logistic'))
        %apply logistic regression model
        nvar=779;
        options= gaoptimset(options,'PopulationSize',PopulationSize,'PopInitRange',[-10;10],'Generations',100,'UseParallel','always','Vectorized','on','CrossoverFcn',{@crossoverarithmetic},'CrossoverFraction',0.5,'TolFun',10^(-10),'MigrationDirection','both','InitialPopulation',[],'MutationFcn',{@mutationuniform,1/nvar},'DistanceMeasureFcn',{@distancecrowding, 'phenotype'},'ParetoFraction',0.5,'Display','off','PlotFcns',{@gaplotpareto});
        [X,FVAL,~,OUTPUT,POPULATION,SCORE] = gamultiobj(@fitnessLogistic_ndefects,nvar,[],[],[],[],-100*ones(1,nvar),100*ones(1,nvar),options);
    elseif (strcmpi(model,'dtree'))
        %compute the structure of decision tree
        A=importdata('training.mat');
        b=importdata('nbug_training.mat');b=b>0;
        t=classregtree(A,b);
        save('tree.mat','t','-mat')
        %identify the number of decision nodes
        nvar=sum(~isnan(cutpoint(t)));
        %runGA
        options= gaoptimset(options,'PopulationSize',PopulationSize,'PopInitRange',[-10;10],'Generations',100,'UseParallel','always','CrossoverFcn',{@crossoverarithmetic},'CrossoverFraction',0.5,'TolFun',10^(-10),'MigrationDirection','both','InitialPopulation',[],'MutationFcn',{@mutationuniform,1/nvar},'DistanceMeasureFcn',{@distancecrowding, 'phenotype'},'ParetoFraction',0.5,'Display','off','PlotFcns',{@gaplotpareto});
        [X,FVAL,~,OUTPUT,POPULATION,SCORE] = gamultiobj(@fitnessTree_ndefects,nvar,[],[],[],[],-100*ones(1,nvar),100*ones(1,nvar),options);
    else
        warning('Undefined Prediction Model');
    end
else
    warning('Undefined Type of Precition. It must be nclasses or ndefects.');
end
end