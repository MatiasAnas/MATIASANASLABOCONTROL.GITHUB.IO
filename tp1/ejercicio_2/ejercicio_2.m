close all;
clear;

T_INICIO_DE_PRIMER_ESCALON = 0;
T_INICIO_DE_SEGUNDO_ESCALON = 0.25;
T_FINAL_SIMULACION = 0.5;

% Simulo.
simOut = sim('motor.slx','ReturnWorkspaceOutputs','on');

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

A = (velocidad_final - velocidad_inicial) * tau;

% Imprimo parametros.

fprintf('Transferencia Propuesta: H(s) = A / (s * tau + 1) * exp(-t0 * s)\n');
fprintf('Transferencia Resultado: H(s) = %.2f / (s * %.2f + 1) * exp(-%.2f * s)\n', A, tau, t0);


% Grafico De Velocidad VS Tiempo.
figure(1);
plot(tiempos, velocidad);
grid on;
axis([T_INICIO_DE_SEGUNDO_ESCALON, T_FINAL_SIMULACION, velocidad_inicial, velocidad_final]);
title('Velocidad VS Tiempo');
xlabel('Tiempo (s)');
ylabel('Velocidad (RPM)');
referencia = (0.63 * ((velocidad_final - velocidad_inicial))+velocidad_inicial);
line([0 T_FINAL_SIMULACION], [referencia referencia], 'Color','red','LineStyle','--');
line([tiempos(i) tiempos(i)], [0 velocidad_final], 'Color','red','LineStyle','--');
