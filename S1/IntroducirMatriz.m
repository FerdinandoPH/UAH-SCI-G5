function Resultado = IntroducirMatriz(Dimensiones)

if numel(Dimensiones) == 1 % numel: número de elementos de un array/matriz
    filas = Dimensiones;
    cols = Dimensiones;
else
    filas = Dimensiones(1);
    cols = Dimensiones(2);
end

Resultado = zeros(filas, cols);
randomizar = false;

disp(['Introduzca los valores de la matriz ' num2str(filas) 'x' num2str(cols) ' (escriba "r" para rellenar aleatoriamente el resto de valores)']);
% El código es muy sencillo: un bucle que pide un valor (o genera uno aleatorio) iterando por cada posición de la matriz.
for i = 1:filas
    for j = 1:cols
        if randomizar
            Resultado(i,j) = randi(100);
        else
            valor = input(['Elemento (' num2str(i) ',' num2str(j) '): '], 's'); % La 's' es para leer como string y no convertir directamente a número (daría error con la 'r')
            if strcmpi(valor, 'r')
                disp('Rellenando aleatoriamente el resto de la matriz...');
                randomizar = true;
                Resultado(i,j) = randi(100);
            else
                Resultado(i,j) = str2double(valor); % No existe 'str2int' al parecer, pero no importa, no se muestra el .0
            end
        end
    end
end

% disp ('Matriz introducida:');
% disp(Resultado);
end
