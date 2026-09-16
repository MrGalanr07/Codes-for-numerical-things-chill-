clc
clear all
close all
format long

% Definimos los parámetros del código

k=6; % potencia

n = 2^k; % tamaño de la matriz como una potencia de 2

A = rand([n, n]); % matriz aleatoria de nxn

B = rand([n, n]); % matriz aleatoria de nxn

AxB = zeros(size(A)); % matriz de ceros de nxn

% Acá programamos el producto matricial usual con operaciones suma y
% multiplicación por escalar

for i = 1:n % el primer bucle recorre las filas

    for j = 1:n % el segundo bucle recorre las columnas

        sum = 0; % empezamos con un sumando igual a 0

        for l = 1:n % el tercer bucle está relacionado con la suma de escalares

            sum = sum + A(i, l)*B(l, j); % suma de cada entrada 
                                         % AxB(i, j) = sum l=0 l=n A(i,l)*B(l, j)
                                         
        end
        
        AxB(i, j) = sum; % componente i,j de la matriz producto
    
    end

end

% Así que definimos una función

function AxB = prodAB(A, B)

    n = size(A, 1);

    C = zeros(size(A));

    for i = 1:n

        for j = 1:n

            suma = 0;

            for l = 1:n

                suma = suma + A(i, l)*B(l, j);

            end

            C(i, j) = suma;

        end

    end

    AxB = C;

end

% Una vez definida nuestra función multiplicación, podemos empezar a pensar
% en multiplicación de matrices por bloques

% El ejercicio pide [W, X; Y, Z] = [A, B; C, D]*[E, F; G, H] con las
% fórmulas de Straussen
% El producto usual nos daría W = A*E + B*G, X = A*F + B*H, Y = C*E + D*G,
% Z = C*F + D*H

%% Programamos el producto usual por bloques

function zeta = block_prod(A1, B1)

n = length(A1); % Número de filas y columnas, es múltiplo de 2

m = n/2; % Este parámetro define hasta donde van mis matrices en los bloques 

% Definimos los bloques
A = A1(1:m, 1:m); B = A1(1:m, m+1:n);
C = A1(m+1:n, 1:m); D = A1(m+1:n, m+1:n);

E = B1(1:m, 1:m); F = B1(1:m, m+1:n);
G = B1(m+1:n, 1:m); H = B1(m+1:n, m+1:n);

% Definimos los productos
W = prodAB(A, E) + prodAB(B, G); 
X = prodAB(A, F) + prodAB(B, H); 
Y = prodAB(C, E) + prodAB(D, G);
Z = prodAB(C, F) + prodAB(D, H);

zeta = [W, X; Y, Z]; % Resultado: matriz aumentada luego de hacer la multiplicación por bloques

end

matrix_rand = cell(1, 8); % Creamos una celda vacía para guardar las 8 matrices involucradas en el producto

% Llenamos la celda con 8 matrices aleatorias de nxn 
for i=1:8

    matrix_rand{1, i} = rand([n, n]);

end

%Creamos los bloques A1 y B1 con estas matrices

A1 = [matrix_rand{1,1}, matrix_rand{1,2}; matrix_rand{1,3}, matrix_rand{1,4}];
B1 = [matrix_rand{1,5}, matrix_rand{1,6}; matrix_rand{1,7}, matrix_rand{1,8}];

A1xB1 = block_prod(A1, B1); % Usamos la función para hacer la multiplicación por bloques
