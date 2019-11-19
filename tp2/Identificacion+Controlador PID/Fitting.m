 clc;close all;clear all;
 

%estos datos son de la identificacion vieja
%load('tout.mat')
%load('velocidades.mat')
%load('pwm.mat')


M=csvread('datos_identificacion.txt');

t=M(:,1)/1000;
p=M(:,2);
v=M(:,3);

t=t(50:end);
v=v(50:end);
p=p(50:end);



%velocidades es 0 hasta la fila 51, asi que para ajustar achico ambos vectores

% v = velocidades(50:end);

%tout va en intervalos de 0.2 asi que genero un t acorde
%t = 0:0.2:16.4;

%pwm
% pwm = double(pwm);
% p = double(pwm(50:end));

%veo si plotea bien
figure(1);
plot(t,v,t,p);
grid on;
hold on;



%ver el identification toolbox
s = tf('s');



G = 425.5/(s+30.87); %1 polo %int conf : 81.36
G2 = 1.211e05/((s+290.5995)*(s+30.2292)); %2 polos % int conf : 86.28
G3 = (2.531*s + 374.4)/(s+27.14); %1 zero, 1 polos int conf : 86.03
G4 = (-2.649e04*s + 7.134e06)/((s+17133.03)*(s+30.21));%1 zero, dos polos int conf 86.28
%nota, G4 es inestable a lazo cerrado, pero muy justito, dividiendo por 2
%se hace estable pero no nos sirve del todo,
opt = stepDataOptions('StepAmplitude',255);

figure(2)
plot(t-1,v,'g');
hold on;
step(G,opt,10)
step(G2,opt,10)
step(G3,opt,10)
step(G4,opt,10)
grid on;
xticks([0 0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2 0.22 0.24 0.26 0.28 0.3 0.32 0.34 0.36 0.38 0.4 0.42 0.44 0.46 0.48 0.5]);
legend('Data Original','1Polo','2Polos','1Zero 1Polo','1Zero, 2Polos')
xlim([0 0.5])
ylim([0 4000])

%vamos al sisotool
%requisitos: OS<3% , TS<0.1s

C = 0.16819*(s+37.31)/s;


%finalmente se uso C2 como controlador
C2= 0.06*(s+5)/s;
%Graficamos la planta a lazo cerrado con controlador

figure();

step(feedback(G2*C2,1),opt)
grid on;
