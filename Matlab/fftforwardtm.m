function xout = fftforwardtm(a1,d_eps,xin)

Np=sqrt(size(xin,1));

x0=xin(1:Np^2,1).*d_eps;
x1=reshape(x0,Np,Np);
x1=[x1
    zeros(Np-1,Np)];
x1=[x1 zeros(2*Np-1,Np-1)];



yf=ifft2(a1.*fft2(x1));
yf=yf(Np:2*Np-1,Np:2*Np-1);
xout1(1:Np^2,1)=reshape(yf,Np^2,1)+xin(1:Np^2,1)+xin(1:Np^2,1).*d_eps;

xout=[xout1];
