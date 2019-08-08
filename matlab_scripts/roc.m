function [HR,FAR,LL,tabcont]=roc(obs,forecast);

% [HR,FAR,LL,tab]=roc(obs,forecast)
%
% This function computes the Hit and False Alarm rate between a binary
% vector of observation (obs) and of forecast (forecast). When the event occurs
% in observation or in forecast, the value is = 1, and = 0 otherwise. It
% could be computed from raw or anomalies for example by ;
% a=zeros(size(obs)); a(find(obs <= threshold))=ones*size(find(obs <=
% threshold))
% b=zeros(size(forecast)); b(find(forecast <= threshold))=ones*size(find(
% forecast <= threshold));
% [hr,far,ll,tab]=roc(a,b); will give the hit and false rate for below
% threshold value.
% Hit Rate (HR) is the proportion of events for which a warning was provided
% correctly and False-Alarm Rate (FAR) is the proportion of non-events for
% which a warning was provided incorrectly. The likelihood ratio (LL) is the
% ratio between HR and FAR and is close to 1 when there is no skill, is
% larger than 1 when there is skill and approaches 0 when there is negative
% skill. The table of contingence is displayed as "tab" with on the first
% row, the cases (event;warning), (event;no warning), total event; on the
% second row, the cases (no event;warning), (no event; no warning), total
% no event and the third row, the total warming, the total no warning and
% the number of cases.
%
% Input
% 'obs' : a vector of binary numbers (0 when the event is not observed and 
% 1 when it is)
% 'forecast' : a vector of binary numbers (0 when the event is not 
% forecasted and 1 when it is)
%
% Output
% 'HR' : integer scalar giving the hit rate
% 'FAR' : integer scalar giving the false-alarm rate
% 'LL' : integer scalar likelihood ratio
% tabcont : 2 x 2 contingency table of integer
%
% References
% Mason S.J., Graham N.E., Weather and forecasting, 1999, 14, 713-725
% Kharin V.V., Zwiers F.W., J. Climate, 2003, 16, 4145-4150
%
% Vincent MORON
% May 2005. 

obs=obs(:);
forecast=forecast(:);
E=length(find(obs==1));
EP=length(find(obs==0));
W=length(find(forecast==1));
WP=length(find(forecast==0));
h=length(find(obs ==1 & forecast==1));
m=length(find(obs ==1 & forecast==0));
f=length(find(obs ==0 & forecast==1));
c=length(find(obs ==0 & forecast==0));
HR=h/(h+m);
FAR=f/(f+c);
LL=HR/FAR;
tabcont=[h m E;f c EP;W WP W+WP];