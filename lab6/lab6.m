%L6_RO51_ BistrischiAttila-Roland
close all;clear;clc;
load('setDate.mat');

%x1=50;
x2=370;
y=vel;
x1=1;
yid=y(x1:x2);
uid=u(x1:x2);

figure;
plot(u);title('u intrare');

figure;
plot(y);title('y iesire');

Na=10;
Nb=10;
N=length(yid);
M=Na+Nb;

RU=[];
for i=1:N
    for j=1:Na
        if i>j
            RU(i,j)=-yid(i-j);
        else
            RU(i,j)=0;
        end
    end
end

for i=1:N
    for j=1:Nb
        if i>j
            RU(i,j+Na)=uid(i-j);
        else
            RU(i,j+Na)=0;
        end
    end
end

teta=RU\yid';

%% validare
yval=y((x2+1):end);
uval=u((x2+1):end);
tval=t((x2+1):end);
Nval=length(yval);
RU_val=[];
for i=1:Nval
    for j=1:Na
        if i>j
            RU_val(i,j)=-yval(i-j);
        else
            RU_val(i,j)=0;
        end
    end
end

for i=1:Nval
    for j=1:Nb
        if i>j
            RU_val(i,j+Na)=uval(i-j);
        else
            RU_val(i,j)=0;
        end
    end
end

%% predictie
Nval=length(uval);
yhat=zeros(1,Nval);
for k=2:Nval
    %s=0;
    for i=1:Na
        if i<k
            yhat(k)=yhat(k) -teta(i)*yval(k-i);
            %s=s-teta(i)*yval(k-i);
        end
    end

    for j=1:Nb
        if j<k
            yhat(k)=yhat(k)+teta(j+Na)*uval(k-j);
            %s=s+teta(j+Na)*uval(k-j);
        end
    end
    %yhat(k)=s;
    %      yhat(k)=sum(-teta(1:Na).*yhat((k-1):(k-Na)));
    %      yhat(k)=yhat(k)+  sum(teta((Na+1):Na+Nb)*uval((k-1):(k-Nb)));

    %yhat(k)=sum(RU(k,:)*teta);

end

figure;
plot(tval,yhat);title('predictie for-uri');
hold on;
plot(tval,yval);legend('yhat','yval');

e=yhat-yval;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la predictie for-uri este de: %f\n',emp);

yhat2=RU_val*teta;
figure;
plot(tval,yhat2);title('predictie formula');
hold on;
plot(tval,yval);legend('yhat2','yval');

e=yhat2'-yval;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la predictie formula este de: %f\n',emp);

figure;
plot(tval,yhat);title('yhat-uri');
hold on;
plot(tval,yhat2);legend('yhat','yhat2');

e=yhat'-yhat2;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la cele doua yhat-uri este de: %f\n',emp);

%% simulare
N=length(uval);
y_tilt=zeros(Nval,1);
for k=2:Nval
    %s=0;
    for i=1:Na
        if i<k
            y_tilt(k)=y_tilt(k)+(-teta(i)*y_tilt(k-i));
            %s=s+(-y_tilt(k-i)*teta(i));
        end
    end

    for j=1:Nb
        if j<k
            y_tilt(k)=y_tilt(k)+teta(j+Na)*uval(k-j);
            %s=s+teta(j+Na)*uval(k-j);
        end
    end
    %y_tilt(k)=s;
end

figure;
plot(tval,y_tilt);title('simulare');
hold on;
plot(tval,yval);legend('y tilt','yval');

e=y_tilt-yval';
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la simulare este de: %f\n',emp);



%%
x2=370;
na=7;nb=7;nk=1;

yid=y(x1:x2)';
uid=u(x1:x2);
yval=y((x2+1):end)';
uval=u((x2+1):end);
tval=t((x2+1):end);
idqq=iddata(yval,uval,t(2)-t(1));
model=arx(idqq,[Na,Nb,nk]);


%z=idinput
figure;
plot(yval);
hold on;
compare(model, idqq);




