function [EM_24,EM_48]=error_medio(X)

a=find(X(:,3)>0 | X(:,4)>0);% saco el error medio sólo para los días que sí precipita
Y=X(a,:);
for j=1:length(Y(:,1))
BIAS_24(j)=Y(j,4)-Y(j,3);  %poner como salida para plotear el error medio a 24 horas
end
%EM_24=nansum(BIAS_24)/length(Y(:,1));
EM_24=mean(BIAS_24(isfinite(BIAS_24)));


b=find(X(:,3)>0 | X(:,5)>0);% saco el error medio sólo para los días que sí precipita
YY=X(b,:);
for i=1:length(YY(:,1))
BIAS_48(i)=YY(i,5)-YY(i,3); %poner como salida para plotear el error medio a 48 horas
end
%EM_48=nansum(BIAS_48)/length(YY(:,1));
EM_48=mean(BIAS_48(isfinite(BIAS_48)));

