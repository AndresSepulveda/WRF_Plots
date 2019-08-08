function [obs,forec24,forec48]=trans_bin(X,um)


for h=1:length(X(:,1))
    if X(h,3)>=um
        obs(h)=1;
    else
        obs(h)=0;
    end
   
    if X(h,4)>=um
        forec24(h)=1;
    else
        forec24(h)=0;
    end
   
    if X(h,5)>=um
        forec48(h)=1;
    else
        forec48(h)=0;
    end 
         
end