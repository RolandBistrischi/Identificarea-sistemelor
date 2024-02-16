%% arx neliniar cu na diferit de nb, eroare medie patratica
close all; clear;clc;
load('iddata-19.mat');

uid=id.u;
yid=id.y;


uval=val.u;
yval=val.y;

figure
plot(id);
figure
plot(val);

%Gradul si ordinul
na=2;
nb=3;
m=3;

nk=0;
N=length(uid);

% Identificare
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
% Generarea toate combinatiile
qqqqq=factorial(na+nb+m)/(factorial(m)*factorial(na+nb));
totalVariabile = na + nb;

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
% Validare
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


% Predictie
yhat=phival*teta;

e=yhat-yval;
emp=1/length(e)*sum(e.^2);
fprintf('Eroarea la predictie este de: %f\n',emp);


figure
plot(yhat)
hold on
plot(yval)
legend('yprezis', 'yval')
title('Predictia ')


% Simulare la validare
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
fprintf('Eroarea la simulare la validare: %f\n',emp)


figure
plot(y_tilt)
hold on
plot(yval)
legend("ysimulat_val","yval")
title('Simulare la Validare')
nk=0;
phi=[];
RU=zeros(1,na+nb);
Nid=length(uid);
y_tilt_id=zeros(Nid,1);
phi(1,:)=generarePuteri(RU(1,:),matricePuteri);

for k=2:Nid

    for j=1:na
        if k>j
            RU(k,j)=-y_tilt_id(k-j);
        else
            RU(k,j)=0;
        end
    end

    for j=1:nb
        if k>j
            RU(k,j+na)=uid(k-j);
        else
            RU(k,j+na)=0;
        end
    end

    phi(k,:)=generarePuteri(RU(k,:),matricePuteri);
    y_tilt_id(k)=phi(k,:)*teta;
end



e_id=y_tilt_id-yid;
emp_id=1/length(e_id)*sum(e_id.^2);
fprintf('Eroarea la simulare la identificare: %f\n',emp_id)

figure
plot(y_tilt_id)
hold on
plot(yid)
legend("ysimulat_id","yid")
title('Simulare la Identificare')

%% arx neliniar na=nb, eroare minima
clear;
close all;
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
minim_id(1,:)=[1000,0,0,0];
minim_id(2,:)=[1000,0,0,0];
ysimulat=[];
yprezis=[];

% Gradul polinomului
for m=1:5
% Ordinul lui na si nb
    for na=1:5
        nb=na;

        matricePuteri=[];
        phi=[];
% Identificare
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
% Numarul total de combinari
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
        matricePuteri=dec2base(quatrice , m+1) - '0';
% Generare matrice puteri
        phi=[];
        for i=1:N
            phi(i,:)=generarePuteri(RU(i,:),matricePuteri);
        end

        teta=phi\yid;
        RUval=[];
% Validare
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
%Predictie
        yhat=phival*teta;

        e=yhat-yval;
        emp=1/length(e)*sum(e.^2);
        EMP_Predictie(m,na)=emp;
        if(emp<minim(1,1))
            minim(1,:)=[emp,m,na,nb];
            yprezis=yhat;
        end

% Simulare validare
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
% Simulare identificare
       
        phi=[];
        RU=zeros(1,na+nb);
        Nid=length(uid);
        y_tilt_id=zeros(Nid,1);
        phi(1,:)=generarePuteri(RU(1,:),matricePuteri);

        for k=2:Nid

            for j=1:na
                if k>j
                    RU(k,j)=-y_tilt_id(k-j);
                else
                    RU(k,j)=0;
                end
            end

            for j=1:nb
                if k>j
                    RU(k,j+na)=uid(k-j);
                else
                    RU(k,j+na)=0;
                end
            end

            phi(k,:)=generarePuteri(RU(k,:),matricePuteri);
            y_tilt_id(k)=phi(k,:)*teta;
        end

        e_id=y_tilt_id-yid;
        emp_id=1/length(e_id)*sum(e_id.^2);
        EMP_Similare_id(m,na)=emp_id;

        if(emp_id<minim_id(2,1))
            minim_id(2,:)=[emp_id,m,na,nb];
            ysimulat_id=y_tilt_id;
        end

        lung=lung+1;
    end
end

Grad_m=(1:na)';
tp=table(Grad_m,array2table(EMP_Predictie,'VariableNames',{'1','2','3','4','5'}),'VariableNames',{'Grad M','Ordin Na si Nb'});
fprintf("Erorile la predictie")
disp(tp)

ts=table(Grad_m,array2table(EMP_Similare,'VariableNames',{'1','2','3','4','5'}),'VariableNames',{'Grad M','Ordin Na si Nb'});
fprintf("Erorile la simulare la validare")
disp(ts)

tsi=table(Grad_m,array2table(EMP_Similare_id,'VariableNames',{'1','2','3','4','5'}),'VariableNames',{'Grad M','Ordin Na si Nb'});
fprintf("Erorile la simulare la identificare")
disp(tsi)

fprintf('Eroarea cea mai mica la predictie este de: %f  la m=%d, na=nb=%d\n',minim(1,1),minim(1,2),minim(1,3));

fprintf('Eroarea cea mai mica la simulare este de: %f  la m=%d, na=nb=%d\n',minim(2,1),minim(2,2),minim(2,3));

fprintf('Eroarea cea mai mica la simulare la id este de: %f  la m=%d, na=nb=%d\n',minim_id(2,1),minim_id(2,2),minim_id(2,3));


figure;
plot(yprezis);title('Predictie');
hold on;
plot(yval);legend('y prezis','yval');


figure;
plot(ysimulat);title('Simulare la Validare');
hold on;
plot(yval);legend('y simulat','yval');


figure;
plot(ysimulat_id);title('Simulare la Identificare');
hold on;
plot(yid);legend('y simulat la id','yid');


%%
% Functia pentru generarea puterilor
function puteri=generarePuteri(X,matricePuteri) %returneza liniile din matricea phi

for i=1:length(matricePuteri(:,1))
    q=X.^matricePuteri(i,:);
    puteri(i)=prod(q);
end
end