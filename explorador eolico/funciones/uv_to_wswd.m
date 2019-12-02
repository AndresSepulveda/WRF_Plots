 function [ws,wd] = uv_to_wswd(u, v)
% function that takes vectors (u,v) and converts to  
% wind speed and wind direction (deg from North) vectors
% This version copes with NaNs in vectors: 23 April 2007
% function [ws,wd] = uv_to_wswd2(u, v)

ws = NaN*ones(size(u));
wd = NaN*ones(size(u));
e = find(~isnan(u) & ~isnan(v));
ws(e) = sqrt(u(e).*u(e) + v(e).*v(e));
wd(e) = 270 - (180/pi)*atan2(v(e),u(e));
for i = 1:length(wd)
    if (wd(i) > 360) wd(i) = wd(i)-360; end; 
end;