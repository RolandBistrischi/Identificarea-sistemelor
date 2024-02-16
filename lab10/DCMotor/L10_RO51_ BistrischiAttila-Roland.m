%L10_RO51_ BistrischiAttila-Roland
close all;clc;clear;

N=200;n=70;Te=0.01;
uid=[zeros(50,1);idinput(N,'prbs',[],[-0.8 0.8])];
uval=[zeros(1,40),0.3*ones(1,n),zeros(1,40)];
motor= DCMRun.start();

for k=1:length(uval)
    motor.wait();
    yval(k)=motor.step(uval(k));
end

%plot(uid);
yid=[];

na=4;nb=4;
P=1000*eye(na+nb);
teta_hat(:,1)=zeros(na+nb,1);
phi=[0;0];
e=0;
W=0;
for k=2:length(uid)

    %de citit datele de pe motor: u(k) si y(k)
    yid(k)=motor.step(uid(k));

    for i=1:na
        if k>i
            phi(i)=-yid(k-i);
        else
            phi(i)=0;
        end
    end

    for i=1:nb
        if k>i
            phi(i+na)=uid(k-i);
        else
            phi(i+na)=0;
        end
    end

    e(k)=yid(k)-phi'*teta_hat;
    P=P-(P*phi*phi'*P)/(1+phi'*P*phi);
    W=P*phi;
    teta_hat=teta_hat+W*e(k);

    motor.wait();
end
motor.stop();

A(1)=1;B(1)=0;
A(2:na+1)=teta_hat(1:na);
B(2:nb+1)=teta_hat(na+1:end);
%%
yval=yval';
uval=uval';
validare=iddata(yval,uval,Te);
mod=idpoly(A,B,[],[],[],0,Te);
compare(mod,validare);

