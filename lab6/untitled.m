close all;clc;
load('setDate.mat');
x2=370;
y=vel;


% figure, plot(id);
% figure, plot(val);
uID = u(1:x2);
yID = y(1:x2);
uVal = u((x2+1):end);
yVal = y((x2+1):end);

nA = 7; 
nB = 7;

figure, sgtitle('Identificare');
phiPredictieID = determinaPhi(uID, yID, nA, nB);
theta = determinaTheta(phiPredictieID, yID);
yPredictieID = aproximeaza(length(uID), phiPredictieID, theta);
subplot(121), plot(yID), hold on, plot(yPredictieID), title('Predictie');

yhatSimulareID = asd(uID, theta, nA, nB);
subplot(122), plot(yID), hold on, plot(yhatSimulareID), title('Simulare');



figure, sgtitle('Validare')
phiPredictieVal = determinaPhi(uVal, yVal, nA, nB);
yPredictieVal = aproximeaza(length(uVal), phiPredictieVal, theta);
subplot(121), plot(yVal), hold on, plot(yPredictieVal), title('Predictie');

yhatSimulareVal = asd(uVal, theta, nA, nB);
subplot(122), plot(yVal), hold on, plot(-yhatSimulareVal), title('Simulare');


yid=y(1:x2)';
uid=u(1:x2);
yval=y((x2+1):end)';
uval=u((x2+1):end);
tval=t((x2+1):end);
val=iddata(yval,uval,t(2)-t(1));
figure
modelArx = arx(val,[nA nB 1]);
compare(modelArx, val);

function [phi] = determinaPhi(u,v,nA,nB)
    for k = 1:length(v)
        for na = 1:nA
            if(k>na) phi(k,na) = -v(k-na); else phi(k,na) = 0; end
        end
        for nb = 1:nB
            if(k>nb) phi(k,nA+nb) = u(k-nb); else phi(k,nA+nb) = 0; end
        end
    end
end

function theta = determinaTheta(phi, v)
    theta = phi \ v';
end

function [yhat] = aproximeaza(l, phi, theta)
    for k = 1:l
        yhat(k) = sum(phi(k,:)*theta);
    end
end

function yhat = asd(u, theta, nA, nB)
    yhat = zeros(length(u),1);
    for k = 2:length(u)
        A = 0;
        for na = 1:nA
            if(k>na) A = A + (-yhat(k-na)*theta(na)); end
        end
        for nb = 1:nB
            if(k>nb) A = A + u(k-nb)*theta(nA+nb); end
        end
        yhat(k) = A;
    end
end