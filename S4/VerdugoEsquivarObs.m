%Tiempo de muestreo
Ts=100e-3
% Referencia x-y de posicion
refx=9;
refy=9;
obsx=8;
obsy=8;
% Ejecutar Simulacion
sim('EvitarObstaculo.slx')
% Mostrar
x=salida_x.signals.values;
y=salida_y.signals.values;
figure;
plot(x,y);
grid on;
hold on;
plot(refx, refy, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
plot(obsx, obsy, 'ko', 'MarkerSize', 10, 'LineWidth', 2);