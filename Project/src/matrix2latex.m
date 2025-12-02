function s = matrix2latex(M)

    % ref https://www.mathworks.com/matlabcentral/fileexchange/80629-matlab-matrix-to-latex-conversion-example
    %% Convert

    % Get matrix dimensions
    m = size(M, 1);
    n = size(M, 2);

    % Create first line
    s = sprintf('  \\begin{bmatrix}\n  ');

    % Add matrix content
    for k = 1:m
        for l = 1:n
            s = sprintf('%s %6.2f', s, M(k, l)); % print 3 decimal places, align to 6 characters
            if l < n
                s = sprintf('%s &', s);
            end
        end
        if k < m
            s = sprintf('%s \\cr', s);
        end
        s = sprintf('%s\n  ', s);
    end

    % Add last line
    s = sprintf('%s\\end{bmatrix}\n', s);
end

