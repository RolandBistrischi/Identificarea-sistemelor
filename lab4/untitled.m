close all
clear all
load("lab4_order1_6.mat");
u = data.InputData;
y = data.OutputData;

plot(t,u),hold on,plot(t,y);

u0 = u(1,1);
uss = u(1,1);
umax = max(u);
yss = sum(y(120:130),1)/length(y(120:130));
y0 = yss;
ymax = max(y(1:40));
K = yss/uss;

y1 = y0 + 0.368*(ymax - y0);
[i, index] = min(abs(y(1:100)-y1));
t1 = t(31);
t2 = t(index);
T = t2-t1;

H = tf(K,[T 1]);
ya = lsim(H, u(1:130), t(1:130));
figure, plot(t(1:130), y(1:130)), hold on, plot(t(1:130), ya), legend('System', 'Model'), title('Identificare fara conditii initiale');


A = -1/T;
B = K/T;
C=1;
D=0;
Hss = ss(A,B,C,D);

figure
ya1 = lsim(Hss, u(1:130), t(1:130), y0);
ya2 = lsim(Hss, u(131:330), t(131:330), y0);

plot(t, y), hold on
plot(t(1:130), ya1, '--'), hold on, plot(t(131:330), ya2, '--'), legend('System', 'Model - identificare', 'Model - validare'), title('ID + Val - cu conditii initiale');

mseVal1 = mean(sum((y(131:330)-ya2).^2))



%%
clear all;
close all;
load("lab4_order2_6.mat");
u = data.u;
y = data.y;
Ts = t(2)-t(1);

figure
plot(t,u),hold on,plot(t,y);
u0 = u(1,1);
uss = u(1,1);
umax = max(u);

yss = sum(y(120:130),1)/length(y(120:130));
y0 = yss;
ymax = max(y(1:40));

K = yss/uss;

t00 = t(31);
t01 = 2.4;
t02 = 3.25;
t1 = 1.85;
t2 = 2.65;
t3 = 3.75;
T0 = t3 - t1;
k00 = 38;
k01 = 54;
k02 = 76;

Aplus = Ts*sum(y(k00:k01)-y0);
Aminus = Ts*sum(y0-y(k01:k02));
M = Aminus/Aplus;
z = log(1/M)/sqrt(pi^2+(log(M))^2);
wn = 2*pi/(T0*sqrt(1-z^2));

H = tf(K*wn^2, [1 2*z*wn  wn^2])

A = [0 1; -wn^2 -2*z*wn];
B = [0; K*wn^2];
C = [1 0];
D = 0;
Hss = ss(A,B,C,D);

figure
ya1 = lsim(Hss, u(1:130), t(1:130), [y0 0]);
ya2 = lsim(Hss, u(131:330), t(131:330), [y0 0]);

plot(t, y), hold on
plot(t(1:130), ya1, '--'), hold on, plot(t(131:330), ya2, '--'), legend('System', 'Model - identificare', 'Model - validare'), title('ID + Val - cu conditii initiale');

mseVal2 = mean(sum((y(131:330)-ya2).^2));