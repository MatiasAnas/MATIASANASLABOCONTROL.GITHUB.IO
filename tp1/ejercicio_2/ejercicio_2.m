close all;
clear;

T_INICIO_DE_PRIMER_ESCALON = 0;
T_INICIO_DE_SEGUNDO_ESCALON = 0.25;
T_FINAL_SIMULACION = 0.5;

% Simulo.
simOut = sim('test_motor_2016a.slx','ReturnWorkspaceOutputs','on');

tiempos = simOut.get('tout');
velocidad = simOut.get('yout').signals.values;

velocidad_inicial = velocidad(length(tiempos) / 2);
velocidad_final = velocidad(end);

% Modelo.
% H(s) = A / (tau * s + 1) * exp(-t0 * s)

t0 = 0;

tau = inf;
for i = 1 : length(tiempos)
    if((velocidad(i) - velocidad_inicial) >= (0.63 * (velocidad_final - velocidad_inicial)))
            tau = tiempos(i) - T_INICIO_DE_SEGUNDO_ESCALON;
        break;
    end
end

A = (velocidad_final - velocidad_inicial) / 6;

% Imprimo parametros.

fprintf('Transferencia Propuesta: H(s) = A / (s * tau + 1) * exp(-t0 * s)\n');
fprintf('Transferencia Resultado: H(s) = %.2f / (s * %.2f + 1) * exp(-%.2f * s)\n', A, tau, t0);

% Respuesta al escalon del modelo.

s = tf('s');
M = exp(-t0 * s) * A / (tau * s + 1);

[y, t] = step(M);

velocidad_modelo = y * 6 + velocidad_inicial;
tiempos_modelo = t + T_INICIO_DE_SEGUNDO_ESCALON;

% Error Cuadratico Medio

error_acumulado = 0;

tiempo_actual = tiempos_modelo(1);
i = 1;
while(tiempo_actual <= T_FINAL_SIMULACION)
    % Como los indices en ambos tiempos no son los mismos,
    % debo buscar cuales son los indices i,j que corresponden a los
    % mismos tiempos.
    for j = 1:(length(tiempos) - 1)
        if((tiempos(j) <= tiempo_actual) && (tiempos(j + 1) >= tiempo_actual))
            break;
        end
    end
    
    error_acumulado = error_acumulado + (velocidad(j) - velocidad_modelo(i))^2;
    
    i = i + 1;
    tiempo_actual = tiempos_modelo(i);
end

ecm_raiz = sqrt(error_acumulado / i);

fprintf('SQRT(ECM): %.2f\n', ecm_raiz);

% Grafico De Velocidad VS Tiempo.
figure(1);
hold on;
plot(tiempos, velocidad, 'b');
plot(tiempos_modelo, velocidad_modelo, 'r');
grid on;
axis([T_INICIO_DE_SEGUNDO_ESCALON, T_FINAL_SIMULACION, velocidad_inicial, velocidad_final]);
title('Velocidad VS Tiempo');
xlabel('Tiempo (s)');
ylabel('Velocidad (RPM)');
referencia = (0.63 * ((velocidad_final - velocidad_inicial))+velocidad_inicial);
line([0 T_FINAL_SIMULACION], [referencia referencia], 'Color','red','LineStyle','--');
line([tiempos(i) tiempos(i)], [0 velocidad_final], 'Color','red','LineStyle','--');
legend('Real', 'Modelo');
