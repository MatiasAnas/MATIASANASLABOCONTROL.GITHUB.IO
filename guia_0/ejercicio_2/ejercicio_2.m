close all;
clear;
clc;

t_inicial = 0;
t_final = 500;
x0 = [0; 0];

% Ode45.
[t45, x45] = ode45(@f, [t_inicial, t_final], x0);
% Ode15.
[t15, x15] = ode15s(@f, [t_inicial, t_final], x0);

figure(1);

subplot(2,2,1);
plot(t45, x45(:, 1), '.');
grid on;
axis([0, 500, 0, 1.2])
title('Vc - ODE45');
xlabel('Tiempo (s)');
ylabel('Tension (V)');

subplot(2,2,2);
plot(t15, x15(:, 1), '.r');
grid on;
axis([0, 500, 0, 1.2])
title('Vc - ODE15S');
xlabel('Tiempo (s)');
ylabel('Tension (V)');

subplot(2,2,3);
plot(t45, x45(:, 2), '.');
grid on;
axis([0, 500, 0, 0.012])
title('Ic - ODE45');
xlabel('Tiempo (s)');
ylabel('Corriente (A)');

subplot(2,2,4);
plot(t15, x15(:, 2), '.r');
grid on;
axis([0, 500, 0, 0.012])
title('Ic - ODE15S');
xlabel('Tiempo (s)');
ylabel('Corriente (A)');