close all
clear all

% Coordenadas a mostrar en la rejilla (rango se define como inicio:paso:fin)
x = -5:0.1:5;
y = -5:0.1:5;
[X,Y] = meshgrid(x,y); % meshgrid toma dos vectores, y crea dos matrices para que cada par de coordenadas posibles tenga una posición. X repite x numel(y) veces en cada fila, Y repite y numel(x) veces en cada columna.

% Siempre hay que usar "." para las operaciones elemento a elemento
Z = Y.*sin(pi*X/10) + 5*cos((X.^2 + Y.^2)/8) + cos(X+Y).*cos(3*X-Y);

figure;
subplot(2,2,[1 2]); % Divide la ventana de gráfico en 2x2 casillas, y selecciona las dos de arriba (posiciones 1 y 2). Es como en matplotlib
surf(X,Y,Z); % surf dibuja una superficie 3D con los valores Z para cada par (X,Y). Las caras se colorean según la altura Z.
xlabel('x');
ylabel('y');
zlabel('z');
title('Superficie');

subplot(2,2,3); % Abajo a la izquierda
mesh(X,Y,Z); % Como surf, pero sin caras ni color
xlabel('x');
ylabel('y');
zlabel('z');
title('Malla');

subplot(2,2,4); % Abajo a la derecha
contourf(X,Y,Z); % Contorno visto desde arriba, rellenando con color según altura
xlabel('x');
ylabel('y');
title('Contorno');
colorbar; % Añade una leyenda en forma de barra