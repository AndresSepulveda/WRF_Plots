function [MAE24,MAE48,SS_pers24,SS_pers48]=mae_pers(X)

a=find(X(:,3)>0 | X(:,4)<0); % saco el error medio sólo para los días que sí precipita
Y=X(a,:);
for j=1:length(Y(:,1))
mae_24(j)=abs(Y(j,4)-Y(j,3));
end
%MAE24=nansum(mae_24)/length(Y(:,1));
MAE24=mean(mae_24(isfinite(mae_24)));

%%
b=find(X(:,3)>0); % saco el error medio sólo para los días que sí precipita
Y1=X(b,:);
% PERSISTENCIA
   for jj=2:length(Y1(:,1))
       mae_pers(jj)=abs(Y1(jj-1,3)-Y1(jj,3));
   end
  
%%   MAE_PERS=nansum(mae_pers)/(length(Y1(:,1))-1);
   MAE_PERS=mean(mae_pers(isfinite(mae_pers)));
%%

% SKILL SCORE MAE
SS_pers24=(1-(MAE24/MAE_PERS))*100; 

clear j 
c=find(X(:,3)>0 | X(:,5)>0); % saco el error medio sólo para los días que sí precipita
Y2=X(c,:);
for j=1:length(Y2(:,1))
mae_48(j)=abs(Y2(j,5)-Y2(j,3));
end
%%MAE48=nansum(mae_48)/length(Y2(:,1));
MAE48=mean(mae_48(isfinite(mae_48)));

% SKILL SCORE MAE
SS_pers48=(1-(MAE48/MAE_PERS))*100; 




