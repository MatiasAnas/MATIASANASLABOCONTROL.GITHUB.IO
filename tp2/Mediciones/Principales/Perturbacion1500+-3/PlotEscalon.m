clear;clc;close all;

load('control.mat');
load('reference.mat');
load('velocidad.mat');
load('tout.mat');
tout=tout/10;


figure(1);
hold on;
grid on;
yyaxis left

plot(tout, senial_referencia,'LineWidth',4,'Color','b');
plot(tout, senial_velocidad,'LineWidth',1,'Color','g','LineStyle','-');
ylabel('RPM')

yyaxis right

plot(tout, senial_control,'LineWidth',1,'LineStyle','-');

legend('Referencia','Velocidad','PWM 0-100%')
xlabel('Tiempo (segundos)')
ylabel('PWM %')