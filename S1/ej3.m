close all
clear all

dims_a = input('Introduzca las dimensiones de la matriz A (formato: [filas columnas]): ');
A = IntroducirMatriz(dims_a);

dims_b = input('Introduzca las dimensiones de la matriz B (formato: [filas columnas]): ');
B = IntroducirMatriz(dims_b);

disp('Matriz A:');
disp(A);
disp('Transpuesta de A:');
disp(A');
if size(A,1) == size(A,2) && det(A) ~= 0 % Size(variable, 1=filas, 2=columnas)
    disp('Inversa de A:');
    disp(inv(A));
else
    disp('No se puede calcular la inversa de A (matriz no cuadrada o singular)');
end
if size(A,1) == size(A,2)
    disp(['Determinante de A: ' num2str(det(A))]);
else
    disp('No se puede calcular el determinante de A (matriz no cuadrada)');
end
disp(['Rango de A: ' num2str(rank(A))]);
disp('----------------------------------------');

disp('Matriz B:');
disp(B);
disp('Transpuesta de B:');
disp(B');
if size(B,1) == size(B,2) && det(B) ~= 0
    disp('Inversa de B:');
    disp(inv(B));
else
    disp('No se puede calcular la inversa de B (matriz no cuadrada o singular)');
end
if size(B,1) == size(B,2)
    disp(['Determinante de B: ' num2str(det(B))]);
else
    disp('No se puede calcular el determinante de B (matriz no cuadrada)');
end
disp(['Rango de B: ' num2str(rank(B))]);
disp('----------------------------------------');

if size(A,2) == size(B,1)
    disp('Producto A*B (matricial):');
    disp(A*B);
    if isequal(size(A), size(B)) % con isequal se comparan todos los valores de un array/matriz
        disp('Producto A.*B (elemento a elemento):');
        disp(A.*B); % En matlab, .* es elemento a elemento en vez de matricial
    else
        disp('No se puede calcular el producto elemento a elemento (dimensiones distintas)');
    end
else
    disp('No se puede calcular el producto A*B (número de columnas de A distinto del número de filas de B)');
end

fila_concat = [A(1,:) B(1,:)];
disp('Concatenación de la primera fila de A y B:');
disp(fila_concat);

columna_concat = [A(:,1); B(:,1)];
disp('Concatenación de la primera columna de A y B:');
disp(columna_concat);
