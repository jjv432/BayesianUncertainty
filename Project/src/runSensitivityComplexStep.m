function S = runSensitivityComplexStep(mass, yIdeal, tIdeal, simTime, fixedPoint)

    h = 1e-12;
    testPointMatrix = [];
    S = [];
    del = 0.05;
    numSamples = 1e5;

    for i = 1:numel(fixedPoint) % every parameter
        minStep = fixedPoint(i)*(1-del);
        maxStep = fixedPoint(i)*(1+del);
        samples = linspace(minStep, maxStep, numSamples);
        for j = 1:numel(samples) % every test point
            x = samples(j);
            testPointMatrix(i, j) = x;
            testPoint = fixedPoint;
            testPoint(i) = x + 1i * h;
            curS = imag(ModelSimulationCost(testPoint, yIdeal)) / h;
            S(i, j) = curS;
        end
    end

    %** Scaling
    % y0 = ModelSimulationCost(fixedPoint, yIdeal) + 1e-12;
    % p0 = fixedPoint;
    % scaler = p0/y0;
    % 
    % for k = 1:numel(fixedPoint)
    %     S(k, :) = S(k, :) * scaler(k);
    % end


    %** Plot sensitivities
    paramNames = ['L', 't', 'w', 'r', "\alpha", 'E'];
    figure('WindowState','maximized')
    for a = 1:numel(fixedPoint)
        subplot(3, 2, a);
        plot((testPointMatrix(a, :) - fixedPoint(a))/fixedPoint(a), S(a, :), 'k', "LineWidth", 3)
        ylabel("S (\theta_" + string(a) + ")", 'fontweight', 'bold');
        xlabel('%\Delta' + paramNames(a), 'fontweight', 'bold');
        grid on
        ax = gca; % Get the current axes object
        ax.FontSize = 14;
    end
    % sgtitle('Local Sensitivities');
    % saveas(gcf, "Reports/LocalSens.jpg");


    function Cost = ModelSimulationCost(fp, yIdeal)
        s = newSpring(fp(1), fp(2), fp(3), fp(4), mass, fp(5), fp(6));

        y = s.getResponse(simTime);

        Cost = sum( (y - yIdeal).^2 );

    end
end