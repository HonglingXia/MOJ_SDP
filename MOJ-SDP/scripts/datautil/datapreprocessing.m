function data_back = datapreprocessing(data)
      ns=1;nm=2;nf=3;entropy=4;la=5;ld=6;lt=7;fix=8;ndev=9;pd=10;npt=11;exp=12;rexp=13;sexp=14;bug=15;
      churn     = decChurn(data);
      %训练集数据预处理
      data(:,[la,ld,lt,exp,rexp,sexp,ndev,pd,npt,entropy])=data(:,[la,ld,lt,exp,rexp,sexp,ndev,pd,npt,entropy])+1;
      data(:,[ns,nm,nf,entropy,la,ld,lt,ndev,pd,npt,exp,rexp,sexp]) = log(data(:,[ns,nm,nf,entropy,la,ld,lt,ndev,pd,npt,exp,rexp,sexp]));
      churn_p = log(churn+1);

      data(:,[nm,rexp,la,ld,fix])=[];
      %data_train(:,8)=[];
      %x = log(data_train(:,1));
      varx = var(data);
      data=data(:,varx~=0);
      data=[data,churn,churn_p];
      data_back=data;
end