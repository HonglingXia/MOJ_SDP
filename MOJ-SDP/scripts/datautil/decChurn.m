function [y] = decChurn(data)
  nf=3;
  lt=7;
  la=5;
  ld=6;
  nf = data(:,nf);            
  lt = data(:,lt).*nf;         
  lt(lt==0) = lt(lt==0) + 1;
  churn = ((data(:,la) + data(:,ld)).* lt)/2;  % LA and LD was normalized by LT
  y = churn;
end