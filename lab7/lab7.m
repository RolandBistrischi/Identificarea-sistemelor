%L7_RO51_ BistrischiAttila-Roland
close all;
clear;clc;

m=3;
X(1,:)=ones(1,m);
A=zeros(m,m);
a=[];
if(m==3)
    a=[1,0,1];

elseif(m==4)
    a=[1,0,0,1];

elseif(m==5)
    a=[0,1,0,0,1];

elseif(m==6)
    a=[1,0,0,0,0,1];

elseif (m==7)
    a=[1,0,0,0,0,0,1];%pt m=7; 

elseif(m==8)
    a=[1,1,0,0,0,0,1,1];

elseif(m==9)
    a=[0,0,0,1,0,0,0,0,1];

elseif(m==10)
    a=[0,0,1,0,0,0,0,0,0,1];
end
A(1,:)=a;
for i=2:m
    A(i,i-1)=1;
end
N=100;
for i=2:N
     q=X(i-1,:);
     X(i,1)=mod(A(1,:)*q',2);
     
     for j=2:m
         X(i,j)=X(i-1,j-1);
     end
end

SPAB3=X(:,1);
plot(SPAB3);


%%

m=10;
X=[];
X(1,:)=ones(1,m);
A=zeros(m,m);
A=[];
if(m==3)
    a=[1,0,1];

elseif(m==4)
    a=[1,0,0,1];

elseif(m==5)
    a=[0,1,0,0,1];

elseif(m==6)
    a=[1,0,0,0,0,1];

elseif (m==7)
    a=[1,0,0,0,0,0,1];%pt m=7; 

elseif(m==8)
    a=[1,1,0,0,0,0,1,1];

elseif(m==9)
    a=[0,0,0,1,0,0,0,0,1];

elseif(m==10)
    a=[0,0,1,0,0,0,0,0,0,1];
end
A(1,:)=a;
for i=2:m
    A(i,i-1)=1;
end
N=100;
for i=2:N
     q=X(i-1,:);
     X(i,1)=mod(A(1,:)*q',2);
     
     for j=2:m
         X(i,j)=X(i-1,j-1);
     end
end

SPAB10=X(:,1);

%%
T=0.01;
N=200;
a1=-0.7;
b1=0.7;

t=0:T:200;

u=[zeros(1,30),(SPAB3*1.4-0.7)',zeros(1,100),(SPAB10*1.4-0.7)',zeros(1,100),0.4*ones(1,70)];

figure;
plot(u)

%%
%clear;
load('matlabdate.mat');
%load('date2.mat');
y=vel;
figure;
plot(vel);
figure
plot(t,u);
x1=180;
x2=390;

 Na=20;Nb=20;nk=1;
 
 yid3=y(1:x1)';
 uid3=u(1:x1)';
 yid10=y((x1+1):x2)';
 uid10=u((x1+1):x2)';

 yval=y((x2+1):end)';

%  uval1=u((x1+1):x2)';
%  yval1=y((x1+1):x2)';
% 
%  uval2=u((x1+1):x2)';
 uval3=u((x2+1):end)';

 tval=t((x2+1):end);
 idqq=iddata(yid3,uid3,t(2)-t(1));
 model=arx(idqq,[Na,Nb,nk]);
 %Spab 3
figure;
plot(yval);
hold on;
compare(model, idqq);

figure
idqq=iddata(yval,uval3,t(2)-t(1));
compare(model,idqq);title('Pt SPAB3');

%%
%SPAB 10
idqq=iddata(yid10,uid10,t(2)-t(1));
model=arx(idqq,[Na,Nb,nk]);
figure;
plot(yval);
hold on;
compare(model, idqq);


figure
idqq=iddata(yval,uval3,t(2)-t(1));
compare(model,idqq);title('Pt SPAB10');

% %%
% %final
% idqq=iddata(yval,uval3,t(2)-t(1));
% model=arx(idqq,[Na,Nb,nk]); 
% figure;
% plot(yval);
% hold on;
% compare(model, idqq);
