%% ordin 1
clear,clc;
close all;
load('lab3_order1_3.mat');
y=data.y;
u=data.u;
figure;
plot(t, u);
hold on;
plot(t, y),legend('u','y'),xlabel('t'),ylabel('y(t)');

%identificare
Yst=8.9;
Ust=3;

K=Yst/Ust;
yT=Yst*0.632;%trebuie sa ma uit la y=yT
T=2.95;
H=tf(K,[T,1]);
%figure
%step(H);
%lsim(H);


%validare
u_val=u(200:end);
y_val=y(200:end);
tval=t(200:end);

figure;
plot(tval,u_val);
hold on;
plot(tval,y_val);
hold on;
lsim(H,u_val,tval,'g'),xlabel('t'),ylabel('y(t)');
ysim=lsim(H,u_val,tval);legend('u val','y val','H(s)');

e=y_val-ysim;
emp=1/length(e)*sum(e.^2);
fprintf("Eroarea medie pareatica pt ordinul I este: %.4f",emp);


%% ordin 2
load('lab3_order2_3.mat');

y2=data.y;
u2=data.u;

figure;
plot(t,u2);
hold on;
plot(t,y2),legend('u','y'),xlabel('t'),ylabel('y(t)');

Yst=6;
Ust=2;
K=Yst/Ust;
yT2=K*0.632;

T=10.15-3.5;
%T=9-6.8;

ymax=9.074;
%M=9.03986-6;


M=(ymax-K)/K;
%M=(ymax-Yst)/Yst;
%M=1.9;
cita=log(M)/sqrt(pi^2+log(M)*log(M));
wn=2*pi/(T*sqrt(1-cita^2));

H2=tf(K*wn^2,[1,2*cita*wn,wn^2]);
 
%validare

u_val2=u2(200:end);
y_val2=y2(200:end);
tval2=t(200:end);

figure;
plot(tval2,u_val2);
hold on;
plot(tval2,y_val2);
lsim(H2,u_val2,tval2,'g'),legend('u val','y val','H(s)'),xlabel('t'),ylabel('y(t)');
ysim=lsim(H2,u_val2,tval2);

e=y_val2-ysim;
emp2=1/length(e)*sum(e.^2);
fprintf("Eroarea medie pareatica pt ordinul II este: %.4f",emp2);





