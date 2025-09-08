clc; clearvars; close all; format compact

%% Constants
N = 30; % arbitrary value 
h = 2/N;
alpha = .9; % arbitrary value
k = h^2 / 2*alpha; % must be true for this method to work
nu = alpha*k/h^2;

%% Define x axis
i = 0:N;
x = -1 + i*h;

%% Define t axis
j = 0:4*N;
t = j*k;

%% Define original heat distribution
% The heat distribution is chosen to be 1 at all intermediate locations,
% and 0 at either end

u = ones(numel(j), numel(i)); % making fake heat distribution
u(1, 1) = 0; % initial condition
u(1, end) = 0; % initial condition

% vertical dimension is time and horizontal is position

% now, theres a matrix where each column is a temp at a position x, and
% each row represents a time step at each position

% Create the A matrix in the textbook
A = spdiags([nu, 1-2*nu, nu], -1:1, N+1, N+1);
A = full(A);

% go through all the rows and do the forward euler
for a = 1:numel(j)-1
    u_cur = u(a, :);
    u_next = A * u_cur';
    u(a+1, :) = u_next';
end

%% Plotting 
[X, T] = meshgrid(x, t);
figure()
surf(X, T, u);
xlabel('Position')
ylabel('Time')
zlabel('Temperature')
view(220, 20)
title("Temporal and Spatial Temperature Distribution q3.2");

%% Discussion
type q2discussion.txt