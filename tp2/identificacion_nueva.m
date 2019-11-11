clear;
close all;

data = csvread('./datos_identificacion.txt');

tiempo = data(50:end,1) / 1000 - 1;
pwm = data(50:end, 2);
velocidad = data(50:end, 3);

figure(1);
plot(tiempo, velocidad);