clc
clear all
close all
format long

% Una matriz tridiagonal está dafinida por tres vectores a, d, c
% d serán los elementos de la diagonal a_ij tales que i=j
% Así: d = [d_1, ..., d_n]
% mientras que a será la diagonal inferior y c la diagonal superior
% Y: a = [a_1, ..., a_n-1], c = [c_1, ..., c_n-1]

% Nota: para que la factorización LU sea única debemos asegurar que nuestra matriz tiene
% diagonal estrictamente dominante: |a_ii|> sum_j=/i |a_ij| (suma sobre todos los j diferentes de i)

% Empezamos con los parámetros del programa. Necesitamos construir una
% matriz tridiagonal que sea estrictamente dominante

n = 3; % Dimensión de la matriz

a = rand(n-1,1) % Vector de la diagonal inferior
c = rand(n-1,1) % Vector de la diagonal superior

% Diagonal suficientemente grande
d = randi([10, 20], n, 1) % Diagonal principal y estrictamente dominante. Se construye con números aleatorios entre 10 y 20
                          % para asegurar la dominancia estricta

% IMPORTANTE: la matriz debe ser diagonal estrictamente dominante, es decir
% |a_ii| > |a_i1| + |a_i2| + ... + |a_ii-1| + (NO a_ii) + |a_ii+1| + ... +|a_in|
% Como la matriz es tridiagonal comparamos solo con 
% |a_ii| > |a_ii-1| + |a_ii+1|. El resto de elementos en la fila son 0. Por
% esto basta con tomar un números lo suficientemente grandes en la diagonal

A = diag(d) + diag(a,-1) + diag(c,1)

% Ahora, buscamos dos matrices L y U tales que L es bidiagonal inferior con a_ii = 1
% y l = [l_1, ...l_n-1] diagonal inferior tal que l_k = a_k/u_k
% y U es bidiagonal superior tal que a_ii = u_i, donde u_1 = d_1 
% y u_k+1 = d_k+1 - l_k*c_k con k = 1, 2, ..., n-1
% y además que c = [c_1, ..., c_n-1] es diagonal superior


% Probamos la función

[L, U] = trifactor(a, d, c)

control_norm = norm(A - L*U)


% Vamos a crear una función que nos de las matrices L y U

function [L, U] = trifactor(a, d, c)

n = length(d); % Tamaño de la diagonal

u = zeros([n,1]); % empezamos u en ceros y vamos llenando con el for siguiente
u(1)=d(1); % la fórmula dice que u_1 = d_1
l=zeros([n-1,1]); % empezamos en ceros y vamos llenando


% Implementamos las fórmulas con el for
for k=1:length(a)

    l(k) = a(k)/u(k); % fórmula para l, usa los u_k
    u(k+1) = d(k+1) - l(k)*c(k); % fórmula para u_k+1, usa los l_k

end

L = eye(n) + diag(l,-1); % matriz L según definición
U = diag(u) + diag(c, 1); % matriz U según definición

end