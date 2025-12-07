function [S, handle] = runSensitivityComplexStep(mass, yIdeal, tIdeal, simTime, fixedPoint, set)

    h = 1e-12;
    testPointMatrix = [];
    S = [];
    del = 0.05;
    % numSamples = 1e4;
    numSamples = 1e2;

    row = 1;

    for i = set % every free parameter
        minStep = fixedPoint(i)*(1-del);
        maxStep = fixedPoint(i)*(1+del);
        samples = linspace(minStep, maxStep, numSamples);
        for j = 1:numel(samples) % every test point
            x = samples(j);
            testPointMatrix(i, j) = x;
            testPoint = fixedPoint;
            testPoint(i) = x + 1i * h;
            curS = imag(ModelSimulationCost(testPoint, yIdeal)) / h;
            S(row, j) = curS;
        end

        row = row + 1;
    end


    %** Scaling
    p0 = [];
    ctr = 1;
    for j = 1:numel(set)
        p0(ctr) = fixedPoint(set(j));
        ctr = ctr + 1;
    end


    scaler = p0/1;

    for k = 1:numel(set)
        S(k, :) = S(k, :) * scaler(k);
    end


    %** Plot sensitivities
    paramNames = ['L', 't', 'w', 'r', "\alpha", 'E'];
    paramNames = paramNames(set);

    figure('WindowState','maximized')
    ctr = 1;
    for a = 1:numel(fixedPoint)
        if (ismember(a, set))
            subplot(3, 2, ctr);
            plot((testPointMatrix(a, :) - fixedPoint(a))/fixedPoint(a), S(ctr, :), 'k', "LineWidth", 3)
            ylabel("S (\theta_" + string(a) + ")", 'fontweight', 'bold');
            xlabel('%\Delta' + paramNames(ctr), 'fontweight', 'bold');
            grid on
            ax = gca; % Get the current axes object
            ax.FontSize = 14;
            ctr = ctr + 1;
        end

    end
    handle = gcf;
    % sgtitle('Local Sensitivities');

    function Cost = ModelSimulationCost(fp, yIdeal)
        s = newSpring(fp(1), fp(2), fp(3), fp(4), mass, fp(5), fp(6));

        y = s.getResponse(simTime);

        Cost = sum( (y - yIdeal).^2 );

    end
end