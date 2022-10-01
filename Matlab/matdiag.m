function Mout=matdiag(Min,diagvec)

m=size(Min,1);
n=size(Min,2);

s=size(diagvec,1);

if s~=n
    disp('Matrix dimension doesnt agree with the diagonal vector dimensoin')
else
    
    for k=1:n
        Mout(:,k)=Min(:,k)*diagvec(k,1);
    end

end