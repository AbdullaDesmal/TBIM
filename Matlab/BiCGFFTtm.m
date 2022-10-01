 function xout = BiCGFFTtm(a1,d_eps,y,error)



rhoi=1;
alpha=1;
w=1;
n=length(d_eps);
v=zeros(n,1)+1i*zeros(n,1);
p=zeros(n,1)+1i*zeros(n,1);

x=zeros(n,1)+1i*zeros(n,1);
temp=zeros(n,1)+1i*zeros(n,1);

if norm(d_eps)==0
    xout=y;
    disp(strcat('BICGFFTtm converge in =',num2str(0), ' iterations with =',num2str(0),' relative norm error.'))
else


temp=fftforwardtm(a1,d_eps,x);
r=y-temp;

rhat0=r;


for k=1:n
      rhoi_1=rhoi;
      rhoi=transpose(rhat0)*r;
      beta=(rhoi/rhoi_1)*(alpha/w);
      p=r+beta*(p-w*v);
       v=fftforwardtm(a1,d_eps,p);
      alpha=rhoi/(transpose(rhat0)*v);
      s=r-alpha*v;
       t=fftforwardtm(a1,d_eps,s);
      w=(transpose(t)*s)/(transpose(t)*t);
      x=x+alpha*p+w*s;
      r=s-w*t;    
      if norm(r)/norm(y)<error
          break
      end     
     
   
end

 xout=x;
 
 disp(strcat('BICGFFTtm converge in=',num2str(k), ' iterations with=',num2str(norm(r)/norm(y)),' relative norm error.'))
 
end