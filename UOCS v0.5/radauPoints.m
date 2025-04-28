function rPoints = radauPoints(degree)
    % Calculates the radau points of an N-th degree Legendre polynomial.
    % Inputs:
    %   - degree: Desired degree of Legendre polynomial.
    % Outputs:
    %   - rPoints: Radau points.


    % Formulate N-th and (N-1)-th degree Legendre polynomials using
    % MATLAB's inbuilt 'legendreP' function and then add them. These
    % functions are defined symbolically so that 'vpasolve' may be used to
    % calculate the roots.
    rPoints = [];
    for ii = 1:length(degree)
        syms x
        legendrePolyN     = legendreP(degree(ii), x);
        legendrePolyNSub1 = legendreP(degree(ii)-1, x);
        
        radauPoly = (legendrePolyN + legendrePolyNSub1);
    

        % Use combined Legendre polynomial to calculate the Radau points via
        % 'vpasolve'.
        rPoints = [rPoints; double(vpasolve(radauPoly == 0))];
    end
end