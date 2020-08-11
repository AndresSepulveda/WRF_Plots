function[b]=remuestreo(a);
% funcion hecha por Alvaro Diaz, 1997
n=length(a);
for i=1:n
 rr=ceil(rand*n);
 b(i)=a(rr);
end