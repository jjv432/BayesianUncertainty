clc; clearvars; %close all; format compact

%% Constants
N = 30; % arbitray value
h = 2/N;
alpha = .9; % arbitray value
k1 = h^2 / 2*alpha;
k2 = 7*k1; % proves that k can exceed h^2/2*alpha
nu1 = alpha*k1/h^2;
nu2 = alpha*k2/h^2;

%% Define x axis
i = 0:N;
x = -1 + i*h;

%% Define t axis
j = 0:4*N;
t1 = j*k1;
t2 = j*k2;

%% Define original heat distribution
% The heat distribution is chosen to be 1 at all intermediate locations,
% and 0 at either end

u = ones(numel(j), numel(i)); % making fake heat distribution
u(1, 1) = 0; % initial condition
u(1, end) = 0; % initial condition

% Make two different u vectors in order to draw a comparison to the
% previous problem
u1 = u;
u2 = u;

% Create the A matrix for both values of k
A1 = spdiags([-nu1, 1+2*nu1, -nu1], -1:1, N+1, N+1);
A1 = full(A1);
A2 = spdiags([-nu2, 1+2*nu2, -nu2], -1:1, N+1, N+1);
A2 = full(A2);

% go through all the rows and do the forward euler for both sets
for a = 1:numel(j)-1
    u_cur = u1(a, :);
    u_next = A1 \ u_cur';
    u1(a+1, :) = u_next';
end

for a = 1:numel(j)-1
    u_cur = u2(a, :);
    u_next = A2 \ u_cur';
    u2(a+1, :) = u_next';
end

%% Plotting
[X1, T1] = meshgrid(x, t1);
[X2, T2] = meshgrid(x, t2);

figure(1)
surf(X1, T1, u1);
xlabel('Position')
ylabel('Time')
zlabel('Temperature')
view(210, 15)
title("T(x,t) Using k_{Q3.2}");

figure(2)
surf(X1, T2, u2);
xlabel('Position')
ylabel('Time')
zlabel('Temperature')
view(210, 15)
title("T(x, t) Using  7k_{Q3.2}");

%% Discussion
type q3discussion.txt