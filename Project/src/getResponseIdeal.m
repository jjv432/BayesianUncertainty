function [y, t] = getResponseIdeal(KS, KD, m, simTime)
    persistent B C D u

    A = [0, 1; -KS/m, -KD/m];
    B = [0; 1/m];
    C = [1 0];
    D = [0];

    sys = ss(A, B, C, D);

    u = -m*9.81*ones(numel(simTime), 1);

    [y, t] = lsim(sys, u, simTime);

end
