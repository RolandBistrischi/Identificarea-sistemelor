%L9_RO51_ BistrischiAttila-Roland
close all;clear;clc;
load('setDate.mat');

%x1=50;
x2=400;
y=vel;
x1=1;

figure;
plot(u);title('u intrare');

figure;
plot(y);title('y iesire');

na=7;nb=7;nk=1;

yid=y(x1:x2)';
uid=u(x1:x2);
yval=y((x2+1):end)';
uval=u((x2+1):end);
tval=t((x2+1):end);
Ts=t(2)-t(1);

idqq=iddata(yid,uid,Ts);
model=arx(idqq,[na,nb,nk]);

 figure;
compare(model, idqq);

yhat=lsim(model,uid);


phi=[];
N=length(yhat);
for i=1:N
    for j=1:na
        if i>j
             phi(i,j)=-yhat(i-j);
        else
          phi(i,j)=0;
        end
    end
end

for i=1:N
    for j=1:nb
        if i>j
           phi(i,j+na)=uid(i-j);
        else
          phi(i,j+na)=0;
        end
    end
end

teta=phi\yhat;
A(1)=1;B(1)=0;
A(2:na+1)=teta(1:na);
B(2:nb+1)=teta(na+1:end);

ivmodel=idpoly(A,B,1,1,1,0,Ts);
yhat2=lsim(ivmodel,uval);

figure;
plot(yhat2);
 hold on; plot(yval);




