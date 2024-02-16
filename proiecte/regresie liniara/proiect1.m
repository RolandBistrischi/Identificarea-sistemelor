close all;
clear;clc;
load('proj_fit_10.mat');

m=3;


N=id.dims;
X1=id.X{1};
X2=id.X{2};
Y=id.Y;

figure;
subplot(1,2,1); mesh(Y),title('Date de Identificare');xlabel('X'),ylabel('Y'),zlabel('Z');

phi=zeros(N(1),m*2+m-1);
linie=1;
for l=1:N
    for i=1:N
        coloana=1;
        for k=1:m
            for j=1:m
                if (k+j)<=m+2
                    phi(linie,coloana)=X1(i)^(k-1)*X2(l)^(j-1);
                    coloana=coloana+1;
                end
            end
        end
        phi(linie,coloana)=X1(i)^m;
        coloana=coloana+1;
        phi(linie,coloana)=X2(i)^m;
        linie=linie+1;
    end
end

Yi_vector=reshape(Y,N(1)*N(2),1);
teta=phi\Yi_vector;
y_hat=phi*teta;
y_hat_id_3d=reshape(y_hat,N(1),N(2));

subplot(1,2,2);mesh(y_hat_id_3d),title('Y aproximat la Identificare');xlabel('X'),ylabel('Y'),zlabel('Z')


Nval=val.dims;
Xval1=val.X{1};
Xval2=val.X{2};
Yval=val.Y;

figure;
subplot(1,2,1);mesh(Yval),title('Date de Validare');xlabel('X'),ylabel('Y'),zlabel('Z');

phival=zeros(Nval(1),m*2+m-1);
linie=1;
for l=1:Nval
    for i=1:Nval
        coloana=1;
        for k=1:m
            for j=1:m
                if (k+j)<=m+2
                    phival(linie,coloana)=Xval1(i)^(k-1)*Xval2(l)^(j-1);
                    coloana=coloana+1;
                end
            end
        end
        phival(linie,coloana)=Xval1(i)^m;
        coloana=coloana+1;
        phival(linie,coloana)=Xval2(i)^m;
        linie=linie+1;
    end
end


Yval_vector=reshape(Yval,Nval(1)*Nval(2),1);
y_hat_val=phival*teta;
y_hat_val_3d=reshape(y_hat_val,Nval(1),Nval(2));

subplot(1,2,2);mesh(y_hat_val_3d),title('Y aproximat la Validare');xlabel('X'),ylabel('Y'),zlabel('Z')

e=Yval_vector-y_hat_val;
EMP=1/length(e)*sum(e.^2);
fprintf("Eroare Medie Patratica pentru gradul %d este: %f\n",m,EMP);


%%

for g=1:30

    N=id.dims;
    X1=id.X{1};
    X2=id.X{2};
    Y=id.Y;
    phi=zeros(N(1),g*2+g);

    linie=1;
    for l=1:N
        for i=1:N
            coloana=1;
            for k=1:g
                for j=1:g
                    if (k+j)<=g+2
                        phi(linie,coloana)=X1(i)^(k-1)*X2(l)^(j-1);
                        coloana=coloana+1;
                    end
                end
            end
            phi(linie,coloana)=X1(i)^g;
            coloana=coloana+1;
            phi(linie,coloana)=X2(i)^g;
            linie=linie+1;
        end
    end
    Yi_vector=reshape(Y,N(1)*N(2),1);
    teta=phi\Yi_vector;


    Nval=val.dims;
    Xval1=val.X{1};
    Xval2=val.X{2};
    Yval=val.Y;

    phival=zeros(Nval(1),g*2+g);
    linie=1;
    for l=1:Nval
        for i=1:Nval
            coloana=1;
            for k=1:g
                for j=1:g
                    if (k+j)<=g+2
                        phival(linie,coloana)=Xval1(i)^(k-1)*Xval2(l)^(j-1);
                        coloana=coloana+1;
                    end
                end
            end
            phival(linie,coloana)=Xval1(i)^g;
            coloana=coloana+1;
            phival(linie,coloana)=Xval2(i)^g;
            linie=linie+1;
        end
    end

    Yval_vector=reshape(Yval,Nval(1)*Nval(2),1);
    y_hat_val=phival*teta;
    e=Yval_vector-y_hat_val;
    EMP(g)=1/length(e)*sum(e.^2);
end

[minim, index]=min(EMP);
fprintf("Eroare minima pentru gradele polinomului pana la %d este: %f si indexul la care se afla este: %d\n",g,minim,index);
figure;plot(EMP);title("Eroarea medie patratica");xlabel('X'),ylabel('Y'), legend('MSE');