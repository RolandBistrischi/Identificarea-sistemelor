%ex2
close all;
x=0:0.25:4;
y=2*exp(-x.*x)+2*sin(0.67*x+0.1);
g=2.2159 + 1.2430*x - 2.6002*x.^2 + 1.7223*x.^3 - 0.4683*x.^4 + 0.0437*x.^5;

figure;
plot(y);
hold on;
plot(g);
e=y-g;
n=length(e);
emp=1/n*sum(e.^2)
figure;
plot(e);


