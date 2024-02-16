%L8_RO51_ BistrischiAttila-Roland
close all;
clear;clc;

load('datematlab.mat');

y=vel;

figure;
plot(u);

figure;
plot(y);

f=1;
b=1;
nk=2;

x=400;

uid=u(1:x);
uval=u((x+1):end);

yid=y(1:x);
yval=y((x+1):end)';

lmax=1020;
alfa=0.01;
delta=0.01;
teta=zeros(2,2);
teta(:,1)=[b,f]';
l=1;
N=length(yid);

e=[0];
dV_dteta=0;
depsilon_dteta = zeros(2, N);
dedf=[0];
dedb=[0];

a=[];
while (l == 1 || (norm(teta(:, l) - teta(:, l - 1)) >= delta && l <= lmax))
    b=teta(1,l);
    f=teta(2,l);
    l=l+1;
    for k=1:nk 
        e(k)=yid(k);
        depsilon_dteta(:,k)=[0,0];
        dedf(k)=[0];% =depsilon_dteta(1)=[0,0]';
        dedb(k)=[0];% =depsilon_dteta(2)=[0,0]';
    end

    for k=nk+1:N
        e(k)=-f*e(k-1)+yid(k)+f*yid(k-1)-b*uid(k-nk);
        dedf(k)=-e(k-1)-f*dedf(k-1)+yid(k-1);
        dedb(k)=f*dedb(k-1)-uid(k-nk);

        depsilon_dteta(1,k)=dedb(k);
        depsilon_dteta(2,k)=dedf(k);
    end
    %dV_dteta(1)=2/(N-nk)*sum(e.*depsilon_dteta(1,:));
    %dV_dteta(2)=2/(N-nk)*sum(e.*depsilon_dteta(2,:));

    dV_dteta=2/(N-nk)*sum(e.*depsilon_dteta,2);
    H=2/(N-nk)*(depsilon_dteta*depsilon_dteta');
    teta(:,l)=teta(:,l-1)-alfa*(H \dV_dteta);

    a(l)=norm(teta(:, l) - teta(:, l - 1));
end

datele=iddata(yval,uval,t(2)-t(1));

b=teta(1,l);f=teta(2,l);
model=idpoly(1,[0,b],1,1,[1,f],0,t(2)-t(1));

figure;
compare(model,datele);




