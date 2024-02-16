clear;clc;

% u = 0.5*ones(1000, 1);
N=300;
u=[zeros(50,1);idinput(N,'prbs',[],[-0.7 0.7]);zeros(100,1);0.4*ones(200,1)];


[vel, alpha, t] = run(u, '4');
plot(t, vel);