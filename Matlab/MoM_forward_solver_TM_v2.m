clc
close all
clear all

load('ProblemConfiguration.mat')


%%% Dimension of the matrices
number_of_recievers=size(field_loc,1);
number_of_transmitters=size(source_loc,1);
mesh_size=size(point_centers,1);
Np=sqrt(mesh_size);


%%% Constants
epso=8.854187817e-12;
muo=4*pi*1e-7;
c=1/sqrt(epso*muo);
eata=120*pi;
%%% Magnituds of the sources - transmitter
mag_trans=ones(number_of_transmitters,1)+1i*zeros(number_of_transmitters,1);
wo=2*pi*frequency;
ko=wo/c;
Ho=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matrix filler %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculating the incident fields in the mesh
Ez_inc=zeros(mesh_size,number_of_transmitters)+1i*zeros(mesh_size,number_of_transmitters);

for m=1:number_of_transmitters
    for n=1:mesh_size
        dist=sqrt((point_centers(n,1)-source_loc(m,1))^2+(point_centers(n,2)-source_loc(m,2))^2);
        Ez_inc(n,m)=-0.25*mag_trans(m)*wo*muo*besselh(0,2,ko*dist);
    end
end


Zc=1i*0.5*pi*ko*radius(1)*besselj(1,ko*radius(1));
Zmm=0.5*1i*pi*ko*radius(1)*besselh(1,2,ko*radius(1));
for n=1:mesh_size
    if n~=1
        dist=sqrt((point_centers(n,1)-point_centers(1,1))^2+(point_centers(n,2)-point_centers(1,2))^2);
        a1tm(1,n)=Zc*besselh(0,2,ko*dist);
    else
        a1tm(1,n)=Zmm;
    end
end


a1tm=reshape(a1tm(1,1:mesh_size),Np,Np);
a1tm=[a1tm(Np:-1:1,:)
    a1tm(2:Np,:)];
a1tm=[a1tm(:,Np:-1:1) a1tm(:,2:Np)];
a1tmconj=fft2(conj(a1tm));
a1tm=fft2(a1tm);

for m=1:number_of_recievers
    for n=1:mesh_size
        dist=sqrt((point_centers(n,1)-field_loc(m,1))^2+(point_centers(n,2)-field_loc(m,2))^2);
        Hatm(m,n)=Zc*besselh(0,2,ko*dist);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% forward problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,Nsamples]=size(eps_rM);

Ez_scat=zeros(number_of_recievers*number_of_transmitters,Nsamples);
for isamples=1:Nsamples
    epsr=eps_rM(:,isamples)';
    epsc=epsr-1i*sigma/(wo*epso);
    d_eps=epsc-1;
    d_eps=transpose(d_eps);
    Ez=zeros(mesh_size,number_of_transmitters);
    for tr=1:number_of_transmitters
        Ez(:,tr)=BiCGFFTtm(a1tm,d_eps,Ez_inc(:,tr),1e-4);
        Hmat(1*number_of_recievers*(tr-1)+1:1*tr*number_of_recievers,1:mesh_size)=-matdiag(Hatm,Ez(:,tr));
    end
    Ez_scat(:,isamples)=Hmat*d_eps;
    
    disp('==========Sample=============')
    disp(isamples)
end
save machine_learning_data Ez_scat eps_rM