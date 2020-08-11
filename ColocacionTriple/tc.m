function [Q q p]=tc(x)

bx=1;
by=1;
bz=1;

Xt=x(:,1); 
Yt=x(:,2); 
Zt=x(:,3); 
byt=1;
bzt=1;

ene=1:length(Xt);

plot(ene,Xt,'-r.',ene,Yt,'-b.',ene,Zt,'-g.')
legend('X','Y','Z')

for i=1:1000;
	Xt=Xt./bx;
	Yt=Yt./by;
	Zt=Zt./bz;

	ext=(nanmean((Xt-Yt).*(Xt-Zt)));
	eyt=(nanmean((Yt-Xt).*(Yt-Zt)));
	ezt=(nanmean((Zt-Xt).*(Zt-Yt)));
	gammay=(ext)/(eyt);

	Ay=gammay*nanmean(Xt.*Yt);
	By=nanmean(Xt.^2)-gammay*nanmean(Yt.^2);
	Cy=-nanmean(Xt.*Yt);
	by=(-By+sqrt(By^2-4*(Ay*Cy)))/(2*Ay);
	gammaz=(ext)/(ezt);

	Az=gammaz*nanmean(Xt.*Zt);
	Bz=nanmean(Xt.^2)-gammaz*nanmean(Zt.^2);
	Cz=-nanmean(Xt.*Zt);
	bz=(-Bz+sqrt(Bz^2-4*(Az*Cz)))/(2*Az);

	byt=byt*by;
	bzt=bzt*bz;
	extot=sqrt(abs(ext))*bx;
	eytot=sqrt(abs(eyt))*byt;
	eztot=sqrt(abs(ezt))*bzt;

end
Q=[];
if by>=0;
	Q(1)=abs(extot);
	Q(2)=abs(eytot);
	Q(3)=abs(eztot);
else 
	Q(1:3)=NaN
end	

c=cov(x);

q=[];
q(1)=sqrt(c(1,1)-c(1,2).*c(1,3)/c(2,3));
q(2)=sqrt(c(2,2)-c(1,2).*c(2,3)/c(1,3));
q(3)=sqrt(c(3,3)-c(1,3).*c(2,3)/c(1,2));

p=[];

p(1)=sqrt((c(1,2)*c(1,3))/(c(1,1)*c(2,3)));
p(2)=sqrt((c(1,2)*c(2,3))/(c(2,2)*c(1,3)));
p(3)=sqrt((c(1,3)*c(2,3))/(c(3,3)*c(1,2)));

return
