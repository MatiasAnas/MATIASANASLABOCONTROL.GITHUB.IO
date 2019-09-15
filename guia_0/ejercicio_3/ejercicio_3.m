close all;
clear;
clc;

y0 = 1;
x_inicio = 0;
x_final = 1;

options = odeset('RelTol', 1E-10);
[x, y] = ode45(@f, [x_inicio, x_final], y0, options);

%plot(x, y);
y(end)

% La idea es ir viendo cual RelTol es bueno.
% La idea es ir bajando la RelTol y fijandose el y(end).
% Una vez que no hay un cambio significativo, me quedo con esa RelTol.