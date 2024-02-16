%% arx neliniar
close all; clear;clc;
load('iddata-19.mat');
%load('lab6_2.mat')
uid=id.u;
yid=id.y;


uval=val.u;
yval=val.y;

figure
plot(id);
figure
plot(val);

na=2;
nb=2;
m=2;
nk=0;
N=length(uid);

RU=[];
for i=1:N
    for j=1:na
        if i>j
            RU(i,j)=-yid(i-j);
        else
            RU(i,j)=0;
        end
    end
end

for i=1:N
    for j=1:nb
        if i>j
            RU(i,j+na)=uid(i-j);
        else
            RU(i,j+na)=0;
        end
    end
end

qqqqq=factorial(na+nb+m)/(factorial(m)*factorial(na+nb));
totalVariabile = na + nb;
% a=0:((m+1)^(totalVariabile))-1;
%
%
%
% % Generează toate combinațiile
%  toateCombinatiile = dec2base(a,m+1)-'0';
%  suma_pe_linii=sum(toateCombinatiile,2) ;
%
%  %Elimină combinațiile care au suma mai mare decât m
%  matricePuteri = toateCombinatiile(suma_pe_linii<=m,:);
%


for a = 0:((m+1)^(totalVariabile))-1
    combinatie = dec2base(a, m+1) - '0';
    suma_pe_linii(a+1) = sum(combinatie);
end

matricePuteri = dec2base(find(suma_pe_linii <= m) - 1, m+1) - '0';



phi=[];
for i=1:N
    phi(i,:)=generarePuteri(RU(i,:),matricePuteri);
end


teta=phi\yid;
%% validare
for i=1:N
    for j=1:na
        if i>j
            RUval(i,j)=-yval(i-j);
        else
            RUval(i,j)=0;
        end
    end
end

for i=1:N
    for j=1:nb
        if i>j
            RUval(i,j+na)=uval(i-j);
        else
            RUval(i,j+na)=0;
        end
    end
end

phival=[];
for i=1:N
    phival(i,:)=generarePuteri(RUval(i,:),matricePuteri);
end


%% Predictie
yhat=phival*teta;

% figure;
% plot(yhat);title('Predictie');
% hold on;
% plot(yval);legend('yhat','yval');

e=yhat-yval;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la predictie este de: %f\n',emp);

% %% predictie
% Nval=length(uval);
% yhat=zeros(1,Nval);
% for k=1:Nval
% %     for i=1:na
% %         if i<k
% %              yhat(k)=yhat(k) -teta(i)*yval(k-i);
% %              %s=s-teta(i)*yval(k-i);
% %         end
% %     end
% %
% %     for j=1:nb
% %         if j<k
% %              yhat(k)=yhat(k)+teta(j+na)*uval(k-j);
% %         end
% %     end
%
%
%     for j=1:qqqqq
%         %if j<k
%              yhat(k)=yhat(k)+teta(j)*phi(k,j);
%         %end
%     end
%
%     %y_hat(k)= phi(k,:)*teta;
%     %yhat(k)=s;
% %      yhat(k)=sum(-teta(1:Na).*yhat((k-1):(k-Na)));
% %      yhat(k)=yhat(k)+  sum(teta((Na+1):Na+Nb)*uval((k-1):(k-Nb)));
%
% %yhat(k)=sum(RU(k,:)*teta);
%
% end
%
% figure;
% plot(yhat);title('predictie for-uri');
% hold on;
% plot(yval);legend('yhat','yval');
%
% e=yhat-yval';
% emp=1/length(e)*sum(e.^2);
% fprintf('Eroarea la predictie este de: %f\n',emp);

%% simulare
nk=0;
phival=[];
RUval=zeros(1,na+nb);
Nval=length(uval);
y_tilt=zeros(Nval,1);
phival(1,:)=generarePuteri(RUval(1,:),matricePuteri);

for k=2:Nval

    for j=1:na
        if k>j
            RUval(k,j)=-y_tilt(k-j);
        else
            RUval(k,j)=0;
        end
    end

    for j=1:nb
        if k>j
            RUval(k,j+na)=uval(k-j);
        else
            RUval(k,j+na)=0;
        end
    end

    phival(k,:)=generarePuteri(RUval(k,:),matricePuteri);
    y_tilt(k)=phival(k,:)*teta;
end



% figure;
% plot(y_tilt);title('simulare');
% hold on;
% plot(yval);legend('y tilt','yval');

e=y_tilt-yval;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la simulare este de: %f\n',emp);

%figure;plot(y_tilt);


%% eroarea cea mai mica
clear;
load('iddata-19.mat');
uid=id.u;
yid=id.y;


uval=val.u;
yval=val.y;
nk=0;
EMP_Predictie=0;
EMP_Similare=0;
lung=1;
N=length(uid);
minim(1,:)=[1000,0,0,0];
minim(2,:)=[1000,0,0,0];
ysimulat=[];
yprezis=[];
for m=1:4
    for na=1:6
        nb=na;

        matricePuteri=[];
        phi=[];
        RU=[];
        for i=1:N
            for j=1:na
                if i>j
                    RU(i,j)=-yid(i-j);
                else
                    RU(i,j)=0;
                end
            end
        end

        for i=1:N
            for j=1:nb
                if i>j
                    RU(i,j+na)=uid(i-j);
                else
                    RU(i,j+na)=0;
                end
            end
        end
        combinatie=0;

        matricePuteri=[];
        qqqqq=factorial(na+nb+m)/(factorial(m)*factorial(na+nb));
        suma_pe_linii=zeros(1,qqqqq);
        totalVariabile = na + nb;
        quatrice=zeros(1,qqqqq);
        i=1;
        a=-1;
        for rrr = 0:((m+1)^(totalVariabile))-1
            a=a+1;
            combinatie = dec2base(a, m+1) - '0';
            wwww= sum(combinatie);
            if wwww<=m
                quatrice(i)=a;
                i=i+1;
            else
                sum_de_skip=0;
                zzz=length(combinatie);
                iesi=0;
                for x=1:zzz
                    sum_de_skip=sum_de_skip+combinatie(x);
                    if(sum_de_skip>m)
                        iesi=1;
                        carry = 1;

                        for c = x:-1:1
                            suma = combinatie(c) + carry;
                            combinatie(c) = mod(suma, m+1);
                            carry = floor(suma / (m+1));
                            if carry == 0
                                break;
                            end
                        end

                        if carry > 0
                            combinatie = [carry, combinatie];
                        end
                        combinatie(x+1:zzz)=0;
                        a=polyval(combinatie, m+1)-1;
                    end
                    if iesi==1
                        break;
                    end
                end
            end

            if i>qqqqq
                break;
            end
        end
        %matricePuteri = dec2base(find(suma_pe_linii <= m) - 1, m+1) - '0';
        %matricePuteri_quatrice = dec2base(quatrice , m+1) - '0';
        matricePuteri=dec2base(quatrice , m+1) - '0';

        phi=[];
        for i=1:N
            phi(i,:)=generarePuteri(RU(i,:),matricePuteri);
        end


        teta=phi\yid;
        RUval=[];
        % validare
        for i=1:N
            for j=1:na
                if i>j
                    RUval(i,j)=-yval(i-j);
                else
                    RUval(i,j)=0;
                end
            end
        end

        for i=1:N
            for j=1:nb
                if i>j
                    RUval(i,j+na)=uval(i-j);
                else
                    RUval(i,j+na)=0;
                end
            end
        end

        phival=[];
        for i=1:N
            phival(i,:)=generarePuteri(RUval(i,:),matricePuteri);
        end

        yhat=phival*teta;
        e=yhat-yval;
        emp=1/length(e)*sum(e.^2);
        EMP_Predictie(m,na)=emp;
        if(emp<minim(1,1))
            minim(1,:)=[emp,m,na,nb];
            yprezis=yhat;
        end

        % simulare
        nk=0;
        phival=[];
        RUval=zeros(1,na+nb);
        Nval=length(uval);
        y_tilt=zeros(Nval,1);
        phival(1,:)=generarePuteri(RUval(1,:),matricePuteri);

        for k=2:Nval

            for j=1:na
                if k>j
                    RUval(k,j)=-y_tilt(k-j);
                else
                    RUval(k,j)=0;
                end
            end

            for j=1:nb
                if k>j
                    RUval(k,j+na)=uval(k-j);
                else
                    RUval(k,j+na)=0;
                end
            end

            phival(k,:)=generarePuteri(RUval(k,:),matricePuteri);
            y_tilt(k)=phival(k,:)*teta;
        end

        e=y_tilt-yval;
        emp=1/length(e)*sum(e.^2);
        EMP_Similare(m,na)=emp;
        if(emp<minim(2,1))
            minim(2,:)=[emp,m,na,nb];
            ysimulat=y_tilt;
        end

        lung=lung+1;

    end
end
% figure; plot(EMP_Predictie);title('EMP la Predictie');
% figure; plot(EMP_Similare);title('EMP la Simulare');

%[minim,index]=min(EMP_Predictie);
fprintf('Eroarea cea mai mica la predictie este de: %f  la m=%d, na=nb=%d\n',minim(1,1),minim(1,2),minim(1,3));

%[minim,index]=min(EMP_Similare);
fprintf('Eroarea cea mai mica la simulare este de: %f  la m=%d, na=nb=%d\n',minim(2,1),minim(2,2),minim(2,3));

figure;mesh(EMP_Predictie);title('EMP la Predictie');
figure; mesh(EMP_Similare);title('EMP la Simulare');

figure;
plot(yprezis);title('Predictie');
hold on;
plot(yval);legend('y prezis','yval');


figure;
plot(ysimulat);title('Simulare');
hold on;
plot(yval);legend('y simulat','yval');


%%
function puteri=generarePuteri(X,matricePuteri) %returneza liniile din matricea phi
%     X=[];
%     puteri=[];
%     for i=1:length(V)
%         X(i)=RU(V(i),i);
%     end
for i=1:length(matricePuteri(:,1))
    q=X.^matricePuteri(i,:);
    puteri(i)=prod(q);
end
end