%Tiempo de muestreo
Ts=100e-3
% Referencia x-y de posicion
refx=10*rand-5;
refy=10*rand-5;
disp([refx,refy])
% Ejecutar Simulacion
sim('PositionControlBorroso_1destino.slx')
% Mostrar
x=salida_x.signals.values;
y=salida_y.signals.values;
figure;
grid on;
hold on;
plot(x,y);
plot(refx, refy, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
