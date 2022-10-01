



clc
clear


load('ProblemConfiguration.mat')
load('machine_learning_data.mat')


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

Atm=zeros(mesh_size);
for n=1:mesh_size
    for m=1:mesh_size
        if n~=m
            dist=sqrt((point_centers(n,1)-point_centers(m,1))^2+(point_centers(n,2)-point_centers(m,2))^2);
            Atm(m,n)=Zc*besselh(0,2,ko*dist);
        else
            Atm(m,n)=Zmm+1;
        end
    end
end

a1tm=reshape(a1tm(1,1:mesh_size),Np,Np);
a1tm=[a1tm(Np:-1:1,:)
    a1tm(2:Np,:)];
a1tm=[a1tm(:,Np:-1:1) a1tm(:,2:Np)];
a1tmconj=fft2(conj(a1tm));
a1tm=fft2(a1tm);




a1tmC=reshape(Atm(1,1:mesh_size),Np,Np);
a1tmC=[a1tmC(Np:-1:1,:)
    a1tmC(2:Np,:)];
a1tmC=[a1tmC(:,Np:-1:1) a1tmC(:,2:Np)];
a1tmconjC=fft2(conj(a1tmC));
a1tmR=fft2(real(a1tmC));
a1tmI=fft2(imag(a1tmC));


for m=1:number_of_recievers
    for n=1:mesh_size
        dist=sqrt((point_centers(n,1)-field_loc(m,1))^2+(point_centers(n,2)-field_loc(m,2))^2);
        Hatm(m,n)=Zc*besselh(0,2,ko*dist);
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% forward problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,Nsamples]=size(eps_rM);



for tr=1:number_of_transmitters
    Hmat(1*number_of_recievers*(tr-1)+1:1*tr*number_of_recievers,1:mesh_size)=-matdiag(Hatm,Ez_inc(:,tr));
end
Hmatconj=Hmat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



nTx=number_of_transmitters;
nRx=number_of_recievers;
nMeas=number_of_transmitters*number_of_recievers;
N=mesh_size;
Emea=zeros(Nsamples,number_of_recievers,number_of_transmitters);
d_epsaM=zeros(Nsamples,N);
for isamples=1:Nsamples
    epsr=eps_rM(:,isamples)';
    epsc=epsr-1i*sigma/(wo*epso);
    d_epsaM(isamples,:)=epsc-1;
    Ez_scat(:,isamples)=awgn(Ez_scat(:,isamples),25,'measured');
    Emea(isamples,:,:)=reshape(Ez_scat(:,isamples),number_of_recievers,number_of_transmitters);
end
save dataForPythonBIMcmplx25dB nTx nRx nMeas N Emea d_epsaM Np Hatm Atm Ez_inc a1tm a1tmC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
