close all;
dimensiones = size(Control);

senial_control = reshape(Control, [1, dimensiones(3)]);
senial_referencia = reshape(Reference, [1, dimensiones(3)]);
senial_velocidad = reshape(Speed, [1, dimensiones(3)]);

figure(1);
hold on;

plot(tout, senial_control);
plot(tout, senial_referencia);
plot(tout, senial_velocidad);

filename = 'control.mat';
save(filename)

filename = 'reference.mat';
save(filename)

filename = 'velocidad.mat';
save(filename)

filename = 'tout.mat';
save(filename)