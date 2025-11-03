clc; clear all; close all

%% INCOMPLETE !!!!!!!!!!!!!!!!!!!!!
% pg 186

% theta = [r; K; z0]

%% Pt 1
thresh = 1e-4; % nu

%% Pt 2
% i is the numel of time
% j is numel of params

time = 1:10;
i = numel(time);
j = 3;

syms r K z0 t

theta = [r; K; z0];

z = K / (1 + (K/z0 - 1) * exp(r * t));

%dz/dr
dz_dr = simplify(diff(z, r));

%dz/dK
dz_dK = simplify(diff(z, K));

% dZ/dz0
dz_dZ0 = simplify(diff(z, z0));

derivs = [dz_dr; dz_dK; dz_dZ0];

theta_names = {"r"; "K"; "z0"; "t"};

for ii = 1:i % time

    theta_now = [output_function(time(ii)); time(ii)];

    for jj = 1:j % theta
        theta_star_j = theta_now(jj);
        df_dth_j_eqn = derivs(jj, 1);
        df_dth_j = subs(df_dth_j_eqn, theta_names, theta_now);
        S(ii, jj)= double(theta_star_j * df_dth_j);

    end
end

function out = output_function(time)
    r = sin(time);
    K = exp(time);
    z0 = 3;
    out = [r; K; z0];
end

%% Part 3

F = transpose(S) * S;
[F_eig, F_eig_vect] = eig(F);
F_eig = sort(F_eig, 'descend');
L = 0;

%% Part 4
lam_1 = F_eig(1);
lam_p = F_eig(end);

m = [];

if (lam_p/lam_1 > thresh)
    L = {};
    disp("All vars are identifiable");
else
    for i = 1:numel(F_eig) - 1
        if ((F_eig(i)/lam_1) > thresh) && ((F_eig(i + 1)/lam_1) <=thresh)
            m = i;
        end

    end

end