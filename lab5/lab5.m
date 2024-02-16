%L5_RO51_ BistrischiAttila-Roland
close all;clear;clc;
load('matlab5.mat');
%load('lab5_4.mat');
% figure
% plot(id.u)
% figure
% plot(tid,id.y)
% 
% 
% 
% figure
% plot(tval,val.u)
% figure
% plot(tval,val.y)


%%
y=vel;

%u=detrend(u);
figure;
plot(t,u);title('u de inceput');
%  figure
%  plot(t,alpha);title('alpha');
figure
plot(t,y);title('y de inceput');
% %% de la curs
% M=100;
% plotlevel=1;
% Ts=abs(u(200)-u(201));
% data=iddata(u,y',Ts);
% 
% [c, tau] = xcorr(u);
% figure, plot(tau,c);title('tau si c');
% fir = cra(data, M, 0, plotlevel);
% yhat = conv(fir, u); yhat = yhat(1:length(u));
% 
% figure, plot(t,yhat);title('primu yhat ');
% 
% yhat = conv(fir, alpha); yhat = yhat(1:length(alpha));
% figure, plot(t,yhat);title('al doilea yhat ');

%%
N=length(u);
M=100;


ryu=zeros(N,1);
ru=zeros(N,1);

for tao=1:N
    for k=1:N-tao+1
        ru(tao)=ru(tao)+u(k+tao-1)*u(k);        
        ryu(tao)=ryu(tao)+ y(k+tao-1)*u(k);
    end
    %ru(tao)=1/N* sum(u(k+tao-1).*u(k));
    %ryu(tao)=1/N* sum(y(k+tao-1).*u(k)); % fara for
    ru(tao)=ru(tao)/N;
    ryu(tao)=ryu(tao)/N;
end

%%
RU=zeros(N,M);
% for i=1:M
%     for j=i:M
%         RU(i,j)=ru(j-i+1);
%         RU(j,i)=RU(i,j);
%     end
% end
% for i=M:N
%     for j=1:M
%         RU(i,j)=ru(i-j+1);
%     end
% end

for i=1:N
    for j=1:M
        RU(i,j)=ru(abs(j-i)+1);  %de la Claudiu
    end
end

 h=RU\ryu;
 figure;
 plot(h);title('plot h');

%% validare
uval=u(820:end);
yval=y(820:end);

% yhat1=zeros(1,N);
% for k=1:N
%     for j=1:M
%          if(k>j)
%              yhat1(k)=yhat1(k)+h(j)*u(k-j+1);
%          end
%     end
% end
yhat=conv(h,uval);
yhat=yhat(1:length(yval));

figure;
plot(t(1:length(yhat)),yhat);
hold on;
plot(t(1:length(yval)),yval);
title('Yhat de mine');

e=yval-yhat';
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la M=%d este de %f\n',M,emp);


%% de facut ca la lab 2 si ca la proiect sa aflam (eroarea minima cred?) sa functioneze matricea cu orice M

for M=1:500

    RU=zeros(N,M);
    for i=1:M
        for j=i:M
            RU(i,j)=ru(j-i+1);
            RU(j,i)=RU(i,j);
        end
    end
    for i=M:N
        for j=1:M
            RU(i,j)=ru(i-j+1); 
        end
    end
    
    h=RU\ryu;
%     yhat=zeros(1,N);
%     for k=1:N
%         for j=1:M
%              if(k>j)
%                  yhat(k)=yhat(k)+h(j)*u(k-j+1);
%              end
%         end
%     end
    uval=u(820:end);
    yval=y(820:end);

    yhat=conv(h,uval);
    yhat=yhat(1:length(yval));

    e=yval-yhat';
    emp(M)=1/length(e)*sum(e.^2);

end

[minim, index]=min(emp);
fprintf("\nEroare minima este de %f  si se afla la: %d\n",minim,index);

figure;plot(emp);title("Eroarea patratica");xlabel('X'),ylabel('Y'), legend('MSE');



