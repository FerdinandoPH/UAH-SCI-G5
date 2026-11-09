%Tiempo de muestreo
Ts=100e-3
% Referencia x-y de posicion
refx=10*rand-5;
refy=10*rand-5;
disp([refx,refy])
% Ejecutar Simulacion
sim('PositionControl.slx')
% Mostrar
x=salida_x.signals.values;
y=salida_y.signals.values;
figure;
plot(x,y);
grid on;
hold on;