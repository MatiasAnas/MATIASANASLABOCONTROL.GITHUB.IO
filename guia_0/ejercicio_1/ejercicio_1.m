close all;
clear;
clc;

t_inicial = 0;
t_final = 10;
h = 0.00075;
x0 = 1;

R = 100000;
C = 10E-6;

% Euler (Paso Fijo).
[t_fijo, x_euler] = ode_euler(@f2, t_inicial, t_final, x0, h);
x_analitica_fijo = exp(-t_fijo / R / C);
error_euler = x_euler - x_analitica_fijo;

% Ode45;
[t_variable, x_ode45] = ode45(@f2, [t_inicial, t_final], x0, h);
x_analitica_variable = exp(-t_variable / R / C);
error_ode45 = x_ode45 - x_analitica_variable;

% Respuestas.
figure(1);
hold on;
grid on;
plot(t_fijo, x_analitica_fijo);
plot(t_fijo, x_euler);
plot(t_variable, x_ode45);
title('Soluciones');
legend('Analitica', 'Euler', 'ODE45');
xlabel('Tiempo (s)');
ylabel('Tension (V)');

% Errores Punto A Punto
figure(2);
hold on;
grid on;
plot(t_fijo, error_euler);
plot(t_variable, error_ode45);
title('Errores');
legend('Euler', 'ODE45');
xlabel('Tiempo (s)');
ylabel('Tension (V)');

% Error Cuadratico Medio.
r_ecm_euler = sqrt(sum((x_euler - x_analitica_fijo).^2)/length(t_fijo));
r_ecm_ode45 = sqrt(sum((x_ode45 - x_analitica_variable).^2)/length(t_variable));

fprintf('Raiz ECM Euler: %d | Puntos: %i \n', r_ecm_euler, length(t_fijo));
fprintf('Raiz ECM ODE45: %d | Puntos: %i \n', r_ecm_ode45, length(t_variable));
