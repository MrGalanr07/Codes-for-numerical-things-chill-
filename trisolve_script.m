clc
clear all
close all
format long

% Una matriz tridiagonal está definida por tres vectores a, d, c
% d: diagonal principal
% a: diagonal inferior
% c: diagonal superior

% Para que la factorización LU sea única sin pivoteo,
% trabajamos con una matriz estrictamente diagonal dominante.

% ============================================================
% Parámetros
% ============================================================

n = 3;

a = rand(n-1,1);       % Diagonal inferior
c = rand(n-1,1);       % Diagonal superior

% Diagonal principal suficientemente grande
d = randi([10,20],n,1);

% Construimos la matriz tridiagonal
A = diag(d) + diag(a,-1) + diag(c,1)

% ============================================================
% Factorización LU
% ============================================================

[L,U] = trifactor(a,d,c)

% Construimos el vector b

b = rand(n,1)

% Vamos a resovler Ax = b
%
% Como A = LU:
%
% LUx = b
%
% Definimos z = Ux:
%
% Así tenemos:
% Lz = b
% Ux = z

[z,x] = trisolve(L,U,b)

% Comprobamos la solución

residuo = norm(A*x - b)


% Función para la factorización (construida en la clase anterior)

function [L,U] = trifactor(a,d,c)

n = length(d);

u = zeros(n,1);
u(1) = d(1);

l = zeros(n-1,1);

for k = 1:length(a)

    l(k) = a(k)/u(k);

    u(k+1) = d(k+1) - l(k)*c(k);

end

L = eye(n) + diag(l,-1);

U = diag(u) + diag(c,1);

end


% Función para resolver Ax=b

function [z,x] = trisolve(L,U,b)

n = length(b);

% PRIMER PASO:
%
% Lz = b
%
% Sustitución hacia adelante
% 

z = zeros(n,1);

% Como L tiene diagonal igual a 1:
%
% z_1 = b_1
%
% z_k = b_k - l_k*z_{k-1}

z(1) = b(1);

for k = 2:n

    z(k) = b(k) - L(k,k-1)*z(k-1);

end


% SEGUNDO PASO:
%
% Ux = z
%
% Sustitución hacia atrás

x = zeros(n,1);

% Primero calculamos x_n (que es el último elemento)

x(n) = z(n)/U(n,n);

% Después vamos hacia atrás:
%
% x_k = [z_k - c_k*x_{k+1}]/u_k

for k = n-1:-1:1

    x(k) = (z(k) - U(k,k+1)*x(k+1))/U(k,k);

end

end