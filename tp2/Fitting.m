 clc;close all;clear all;
 

load('tout.mat')
load('velocidades.mat')
load('pwm.mat')

%velocidades es 0 hasta la fila 51, asi que para ajustar achico ambos vectores

v = velocidades(50:end);

%tout va en intervalos de 0.2 asi que genero un t acorde
t = 0:0.2:16.4;

%pwm
pwm = double(pwm);
p = double(pwm(50:end));

%veo si plotea bien
figure(1);
plot(t,v,t,p);
grid on;
hold on;

% Vamos al curve fitter
% %Copiado de la aplicacion de ajuste
% General model Exp2:
%      f(x) = a*exp(b*x) + c*exp(d*x)
% Coefficients (with 95% confidence bounds):
%        a =        3529  (3467, 3592)
%        b =  -0.0004964  (-0.002243, 0.00125)
%        c =       -3739  (-3944, -3533)
%        d =      -2.116  (-2.338, -1.893)
% 
% Goodness of fit:
%   SSE: 9.901e+05
%   R-square: 0.9583
%   Adjusted R-square: 0.9568
%   RMSE: 112
% 
% a = 3529; b = -0.0004964; c = -3739; d = -2.116;
% 
% g1 = a*exp(b*t); g2 = c*exp(d*t); g = g1+g2; plot(t,g) close all;

%ver el identification toolbox
s = tf('s');
G = 42.36/(s+3.08); %1 polo
G2 = 1058/((s+25.34)*(s+3)); %2 polos
G3 = (2.78*s+36.88)/(s+2.681); %1 zero, 1 polos
G4 = -(s*1936-4.567e4)/((s+1100)*(s+3));%1 zero, dos polos
%nota, G4 es inestable a lazo cerrado, pero muy justito, dividiendo por 2
%se hace estable pero no nos sirve del todo,
opt = stepDataOptions('StepAmplitude',255);

figure(2)
plot(t,v,'g');
hold on;
step(G,opt,10)
step(G2,opt,10)
step(G3,opt,10)
step(G4,opt,10)
grid on;
legend('Data Original','1Polo','2Polos','1Zero 1Polo','1Zero, 2Polos')
