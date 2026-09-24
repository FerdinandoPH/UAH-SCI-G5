% Requiere estos add-on: Symbolic Math Toolbox y Control System Toolbox
close all
clear all

syms k z a real % Declara variables simbólicas reales

kvec = 0:15; % Eje de k para dibujar la señal más tarde

f1 = 2 + 5*k + k^2; 
F1 = ztrans(f1, k, z); % Transformada z de f1 (función, variable temporal k, variable de resultado z)
disp("Z(f1(k)) = "); pretty(F1) % pretty(expr): muestra la expresión con fracciones, potencias etc.

f1vec = double(subs(f1, k, kvec)); % Hacemos un vector con el valor de f1(k) para cada k en kvec (y así dibujarla)

figure;
subplot(1,2,1);
stem(kvec, f1vec); % stem(x, y): como plot, pero con diagrama de tallo, que es lo que se usa para señales discretas
xlabel('k');
ylabel('f1(k)');
title('Señal original f1(k) = 2 + 5k + k^2');

subplot(1,2,2);
fplot(F1, [1.1 10]);
set(gca, 'YScale', 'log'); % cambiar el eje actual (y de F1(z)), para que sea de escala logarítmica, y se vea mejor (los valores empiezan en infinito)
xlabel('z');
ylabel('F1(z)');
title('Transformada z: F1(z)');

% Apartado 2 aquí



%---
% T(z) = (0.4z^2)/(z^3 -1z^2 + 0.1z + 0.02)
f3_num = [0.4 0 0]; % Coeficientes del numerador (de mayor a menor grado de z)
f3_denom = [1 -1 0.1 0.02]; % Lo mismo para el denominador

T = tf(f3_num, f3_denom, -1); % tf(num, denom, Ts = tiempo de muestreo, -1 = discreto pero muestreo no especificado): Crea una función de transferencia discreta

figure;
impulse(T); % Calcula y dibuja la respuesta de T(z) al impulso unitario (δ(k))
title('Respuesta al impulso (δ(k)) de T(z)');

figure;
step(T); % Calcula y dibuja la respuesta de T(z) al escalón unitario (u(k))
title('Respuesta al escalón (u(k)) de T(z)');