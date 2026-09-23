close all
clear all

tam = input('Indique el tamaño de la matriz: ');
M = randi(100, tam); % Genera matriz cuadrada tam x tam con números random 1-100
disp("Matriz generada:")
disp (M)

Mimp = zeros(tam, ceil(tam/2));
for i=1:tam
    if mod(i,2) == 1 % Si es columna impar
        Mimp(:, ceil(i/2)) = M(:, i); % Copiar toda la columna (lo de ceil es para que vaya a la siguiente columna de Mimp)
    end
end
disp("Matriz con solo las columnas impares:")
disp(Mimp)

diagonal = diag(M)'; % Lo ponemos en fila para que se vea mejor
disp("Diagonal de la matriz:")
disp(diagonal)

%Hacer un gráfico con los máximos de cada fila (x = número de fila, y = máximo de la fila)
maximos = max(M, [], 2); % Calcular el máximo de cada fila. Los parámetros son matriz, segunda matriz a comparar (si pones vacío, es solo entre una matriz), y el 2 indica que es por fila (1 sería por columna, sin nada es toda la matriz)
disp("Máximos de cada fila:")
disp(maximos)
x = 1:tam;
figure; % Crea una nueva figura (para no sobreescribir la anterior)
bar(x, maximos);
xticks(1:tam); % Para que no salgan decimales en el eje x
xlabel('Número de fila');
ylabel('Máximo de la fila');
title('Máximos por fila');

minimos = min(M, [], 2);
disp("Mínimos de cada fila:")
disp(minimos)
figure;
bar(x, minimos);
xticks(1:tam);
xlabel('Número de fila');
ylabel('Mínimo de la fila');
title('Mínimos por fila');

medias = mean(M, 2); %aquí el 2 también indica que es por fila
disp("Medias de cada fila:")
disp(medias)
figure;
bar(x, medias);
xticks(1:tam);
xlabel('Número de fila');
ylabel('Media de la fila');
title('Medias por fila');

varianzas = var(M, 0, 2); %aquí el 2 también indica que es por fila y el 0 normaliza la varianza
disp("Varianzas de cada fila:")
disp(varianzas)
figure;
bar(x, varianzas);
xticks(1:tam);
xlabel('Número de fila');
ylabel('Varianza de la fila');
title('Varianzas por fila');
