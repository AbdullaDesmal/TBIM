clc
clear all
close all

dx=0.15; dy=0.15;
nsize1x=48;
nsize1y=48;

Xlength=dx*nsize1x;
Ylength=dy*nsize1y;

Xcenters=(0:dx:(Xlength-dx))-Xlength/2;
Ycenters=(0:dx:(Ylength-dy))-Ylength/2;

[Xmesh Ymesh]=meshgrid(Xcenters,Ycenters);
XminShift=min(abs([Xcenters(1),Xcenters(end)]));
YminShift=min(abs([Ycenters(1),Ycenters(end)]));

%------------------------------------------------
% create the grid;
% -----------------------------------------------

% 


ncell=length(Xcenters)*length(Ycenters);

Nsamples=70000;
Ncylinders=3;
iNcylinders=randi(Ncylinders,1,Nsamples);
eps_r_all=ones(nsize1x,nsize1y,Nsamples);


CRx=2*XminShift*(rand(Nsamples,Ncylinders)-0.5);
CRy=2*YminShift*(rand(Nsamples,Ncylinders)-0.5);
Levels=0.6*rand(Nsamples,Ncylinders)+1.2; % min 1.2 and max 1.8
Rin=0.5*min(XminShift,YminShift)*(rand(Nsamples,Ncylinders))+0.16;

for isample=1:Nsamples
    eps_r_init=ones(nsize1x,nsize1y);
    for icylinder=1:iNcylinders(isample)
        R_cell=sqrt((CRx(isample,icylinder)-Xmesh).^2+(CRy(isample,icylinder)-Ymesh).^2);
        eps_r_init(R_cell<=Rin(isample,icylinder))=Levels(isample,icylinder);
    end
    eps_r_all(:,:,isample)=eps_r_init;
end
        

eps_rM=reshape(eps_r_all,ncell,Nsamples);

sigma_r(1:ncell)=0.0E0;
mesh_type(1:ncell)='D';


%%
 figure;
aa=surf(Xmesh,Ymesh,eps_r_all(:,:,5000))
view(0,90);
set(gca,'Fontsize',[16]);
set(gca,'Fontname','Times');
xlabel('x (m)');
ylabel('y (m)');
set(gca,'Fontname','Times');
zlabel('\epsilon_r(x,y)')

hold


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
point_centers=[Xmesh(:) Ymesh(:)];
nTx=16;
nRx=28;
maxM=max(point_centers(:,1));
RadiusTx=5*dx+sqrt(2)*maxM;
RadiusRx=4*dx+sqrt(2)*maxM;
field_loc=RadiusRx*[cos(2*pi*[0:nRx-1]/nRx); sin(2*pi*[0:nRx-1]/nRx)]';
source_loc=RadiusTx*[cos(2*pi*[0:nTx-1]/nTx); sin(2*pi*[0:nTx-1]/nTx)]';

sigma(:)=sigma_r(:);
radius=sqrt(dx*dy/pi);

frequency=110e6;
BICG_tolarance=1e-10;

save ProblemConfiguration BICG_tolarance dx dy eps_rM field_loc frequency point_centers ...
    radius sigma source_loc 