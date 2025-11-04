clc; clearvars; close all
%% Partial Variance, Sobol Indices

syms theta_sym [3 1]

f = myIshigami(theta_sym);

% for i = 1:3
%     f_ints(i) = int(f, theta_sym(i));
% end

%* Eqn 9.9

f0_ = int(int(int(f, theta_sym(1), 0, 1), theta_sym(2), 0, 1), theta_sym(3), 0, 1);
f0 = double(f0_);

range = 1:3;
for i = 1:3
    not_i = range(range~=i);
    f_i_th_i(i) = int(int(f, theta_sym(not_i(1)), 0, 1), theta_sym(not_i(2)), 0, 1) - f0;
end

%* Eqn 9.17

for i = 1:3
    D_= int( (f_i_th_i(i))^2, theta_sym(i), 0, 1);
    D(i) = double(D_);
end

S = D/sum(D); % this equals 1 so should be good :)



%% Morris screening algorithm 9.21

test_points = 2:1000;
delta = 1e-4;
for a = 1:numel(test_points)
    %** 1
    
    R = test_points(a);

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


    %** 3
    mu = sum(d_j_i) / R;

    sigmas = [0 0 0];

    for ii = 1:p % parameters

        for jj = 1:R % Samples
            tmp = (d_j_i(jj, ii) - mu(ii))^2;
            sigmas(ii) = sigmas(ii) + tmp;
        end
        sigmas(ii) = sqrt(sigmas(ii) * (1/(R-1)));
    end

    mus(a, :) = mu;
    sigmas_total(a, :) = sigmas;

end

%% Plotting
figure()

hold on
for i = 1:3
    e_mu = abs( mus(:, i) - S(i) ) ./ mus(:, i);
    e_sig = abs( sigmas_total(:, i) - D(i) ) ./ sigmas_total(:, i);
    subplot(3, 2,2*i -1)

    plot(test_points, e_mu);
    if i ==1
        title("Mu Errors")
    end
    ylabel("Mu_" + string(i));

    if i == 3
        xlabel("R")
    end


    subplot(3, 2,2*i)
    plot(test_points, e_sig);
    if i ==1
        title("Sigma Errors")
    end
    ylabel("Sigma_" + string(i));

    if i == 3
        xlabel("R")
    end


end

saveas(gcf, "Q4plots.jpg");


%% Fns

function f = myIshigami(theta)
    a = 7;
    b = 0.1;
    f = sin(theta(1)) + a * (sin(theta(2)))^2 + b*theta(3)^4 * sin(theta(1));
end