function [t, x] = ode_euler(f, t_inicial, t_final, x0, h)
    puntos = floor((t_final - t_inicial) / h + 1);
    x = zeros(puntos, 1);
    t = linspace(t_inicial, t_final, puntos)';
   
    x(1) = x0;
    for i = 2:length(x)
        x(i) = x(i - 1) + h * f(t(i - 1), x(i - 1));
    end
end