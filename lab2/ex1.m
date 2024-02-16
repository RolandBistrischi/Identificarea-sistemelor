%% lab2 is
close all;
load('lab2_07.mat');

n=24;
N=length(id.X);

y=id.Y;
X=id.X;
phi=zeros(N,n);

for i = 1:N
    phi(i,1)=1;
    phi(i,2)=X(i);
   for j = 3:n+1
      phi(i,j)=phi(i,2)^(j-1); 
    end
end
%theta=phi.^(-1)*y';
theta=phi\y';
y_hat_id=(phi*theta)';

plot(y);
hold on
plot(y_hat_id);
title('Identificare'),legend('id','y hat');

%e_id=y-y_hat_id;
%emp_id=sum(e_id.^2)/n;

%% validare
Nval=length(val.Y);
Yval=val.Y;
X=val.X;
phi_val=zeros(Nval,n);

for i = 1:Nval
    phi_val(i,1)=1;
    phi_val(i,2)=X(i);
   for j = 3:n+1
      phi_val(i,j)=phi_val(i,2)^(j-1);
    end
end
theta_val=phi_val\Yval';
%theta_val=theta;
y_hat_val=phi_val*theta_val;

figure
plot(val.Y);
hold on
plot(y_hat_val);
title('Validare'),legend('val','y hat');

%% eroarea
lung=30;
N=length(id.X);
Nval=length(val.Y);
X=id.X;
y=id.Y;
Xval=val.X;
Yval=val.Y;
emp=zeros(lung,1);
for k=1:lung
    %calculez phi pt fiecare N
    phi=zeros(N,k);
    for i = 1:k
        phi(i,1)=1;
        phi(i,2)=X(i);
       for j = 3:k+1
          phi(i,j)=phi(i,2)^(j-1);
       end
    end
    %calculez eroarea
    theta=phi\y';

    phi_val=zeros(Nval,k);
    
    for i = 1:k
        phi_val(i,1)=1;
        phi_val(i,2)=Xval(i);
       for j = 3:k+1
          phi_val(i,j)=phi_val(i,2)^(j-1);
        end
    end
    
    y_hat=phi_val*theta;
     e_id=Yval-y_hat';
     a=length(e_id);
     emp(k)=1/k*sum(e_id.^2);
end


figure;
plot(emp),title('Erori medii patrate');
[minim,index_minim]=min(emp);
fprintf('Eroarea minima ( %f ) este la polinomul cu gradul:  %d \n',minim,index_minim);








