function getResponseMems(u, kMat, fD_u2)
    
    global idealM;

    A = [0, 1; -KS/idealM, -KD/idealM];
    B = [0; 1/idealM];
    C = [1 0];
    D = [0];

    sys = ss(A, B, C, D);

    simTime = linspace(0, 5, 2000);

    u = -idealM*9.81*ones(numel(simTime), 1);

    [y, t] = lsim(sys, u, simTime);




end