function rWeights = radauWeights(rPoints, degree)
    % Calculates the weights of the radau points corresponding to an N-th
    % degree Legendre polynomial. 
    % Inputs:
    %   - rPoints: Radau points of an N-th degree Legendre polynomial.
    %   - degree: Desired degree of Legendre polynomial.
    % Outputs:
    %   - rWeights: Weights corresponding to the Radau points.
    

    % Form (N-1)-th degree Legendre polynomial, and then evaluate it at all
    % of the Radau points when calculating the corresponding weights.
    rWeights = [];
    for ii = 1:length(degree)
        if ii > 1
            rPointsIter = rPoints(1+sum(degree(1:ii-1)):+sum(degree(1:ii)));
        else
            rPointsIter = rPoints(1:degree(ii));
        end
        legendrePolyNSub1 = @(x) legendreP(degree(ii)-1, x);

        rWeights = [rWeights; 2/degree(ii)^2]; % First weight calculated seperately
        rWeights = [rWeights; (1-rPointsIter(2:end))./(degree(ii)^2*legendrePolyNSub1(rPointsIter(2:end)).^2)];
    end
end