%L4_RO51_ BistrischiAttila-Roland
clear,clc;
close all;
load('lab4_order1_6.mat');
y=data.y;
u=data.u;
figure;
subplot(2,1,1),plot(t,y),legend('y'),xlabel('t'),ylabel('y(t)');
hold on;
subplot(2,1,2),plot(t,u),legend('u'),xlabel('t'),ylabel('u(t)');

ymax=0.28;
Yst=0.12;
Ust=0.5;
a=0.368*(ymax-Yst)+Yst;%trebuie sa ma uit la y=a 
T=5.4-3.6;
K=Yst/Ust;
[A, B, C, D]=tf2ss(K,[T,1]);
sys=ss(A, B, C, D);

% validare
yval=y(110:end);
uval=u(110:end);
tval=t(110:end);
Yst_val=0.12;
x01=Yst_val;

figure;
ysim=lsim(sys,uval,tval,x01);
lsim(sys,uval,tval,x01,'g');
hold on;
plot(tval,yval);
plot(tval,uval);
legend('H(s)','yval','uval');

e=yval-ysim;
emp=1/length(e)*sum(e.^2);
fprintf("Eroarea medie pareatica pt ordinul I este: %.4f",emp);

%% ordinul 2
%close all;
load('lab4_order2_6.mat');

y2=data.y;
u2=data.u;

figure;
subplot(2,1,1),
plot(y2),legend('u'),xlabel('t'),ylabel('y(t)');
hold on;
subplot(2,1,2),
plot(t,u2),legend('u'),xlabel('t'),ylabel('u(t)');

Ust2=0.5;
Yst2=2.5;
K=Yst2/Ust2;
t1=1.52;
t2=2.4;
t3=3.32;
T=2*(t2-t1);
Ts=t(2)-t(1);

yA1=y2(31:55);
yA2=y2(56:78);
A1=Ts*sum(yA1-Yst2);
A2=Ts*sum(yA2-Yst2);
M=abs(A2)/A1;

cita=-log(M)/(sqrt(pi^2+log(M)*log(M)));
wn=2*pi/(T*sqrt(1-cita^2));

%[A,B,C,D]=tf2ss(K*wn^2,[1, 2*cita*wn, wn^2]);
A=[0,1   ;-wn^2,  -2*cita*wn];
B=[0;K*wn^2];
C=[1,0];
D=0;

sys2=ss(A,B,C,D);


%validare
yval2=y2(90:end);
uval2=u2(90:end);
tval2=t(90:end);
Yst_val2=2.5;
%pt Yst_val2=0; emp=0.1817
x02=[Yst_val2,0];

figure;
ysim_val=lsim(sys2,uval2,tval2,x02);
lsim(sys2,uval2,tval2,x02,'g');
hold on;
plot(tval2,yval2);
plot(tval2,uval2);
legend('H(s)','yval','uval');

e2=yval2-ysim_val;
emp2=1/length(e2)*sum(e2.^2);
fprintf("Eroarea medie pareatica pt ordinul II este: %.4f",emp2);






