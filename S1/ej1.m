close all
clear all
%para limpiar variables de otros scripts


A=[1 2; 3 4; 5 6; 7 8]; % Separar números con espacio/coma dentro de una fila, ; para nueva fila
disp("A:")
disp(A)
v=[14; 16; 18; 20];
disp("v:")
disp(v)

B= [A v]; % Para concatenar es la misma lógica pero con matrices (las dimensiones tienen que coincidir)
disp("B:")
disp(B)

Bfil = reshape(B', 1, []); % reshape transforma la matriz en una de 1 fila y [auto] columnas. Como lee los valores columna por columna, hay que transponer primero (con .')

%Alternativamente, se puede hacer con [B(1,:) B(2,:) B(3,:)], pero depende del número de filas (sintáxis es Matriz(fila, columna)). Fila y columna son spliceables

disp("B concatenado en una fila:")
disp(Bfil)

Bcol = reshape(B, [], 1); % Misma lógica para esto
disp ("B concatenado en una columna:")
disp(Bcol)