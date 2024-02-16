
clear;
%u=[zeros(1,30),(SPAB3*1.4-0.7)',zeros(1,100),(SPAB10*1.4-0.7)',zeros(1,100),0.4*ones(1,70)];
load('intrare.mat');
[vel, alpha, t] = run(u, '3');
plot(t, vel);