clc; clearvars; close all
%% Morris screening algorithm 9.21

%** 1
delta = 1e-5;
R = 50;

%** 2
d_j_i = [];
p = 3;
ei = zeros(p, 1);
for j = 1:R
    theta_j = rand(p, 1); % random sample of theta

    for i = 1:numel(theta_j)

        ei(i) = 1;
        d_j(i) = (myIshigami(theta_j + delta*ei) - myIshigami(theta_j))/delta;
        ei(i) = 0;
    end
    d_j_i = [d_j_i; d_j];
    d_j = [];

end

function f = myIshigami(theta)
    a = 7;
    b = 0.1;
    f = sin(theta(1)) + a * (sin(theta(2)))^2 + b*theta(3)^4 * sin(theta(1));
end

%** 3

mu_star = sum(abs(d_j_i)) / R;

mu = sum(d_j_i) / R;

sigma_j_i = [];
for j = 1:R
    cur_d = d_j_i (j, i);

    for i = 1:p
        sigma(i) = sqrt( (1/(R-1)) * sum((cur_d - mu(i))^2) ); % This sum is wrong!!! Should end with one value for each i. Loop j and i
    end

    sigma_j_i = [sigma_j_i; sigma];
    sigma = [];

end

sigma_j_i(end, :)