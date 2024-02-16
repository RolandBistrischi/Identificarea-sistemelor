%u = 0.5*ones(1000, 1);
u=[zeros(10,1);1.4*rand(800,1)-0.7;zeros(50,1);0.2*ones(100,1)];
[vel, alpha, t] = run(u, '3');
plot(t, vel);