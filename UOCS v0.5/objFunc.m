function bolzaCost = objFunc(decision, NLP)
% Cost function for the NLP. LGR collocation of the nonlinear constraints
% is also performed here before being passed to the error function.
% Inputs:
%   - decision: NLP decision vector.
%   - NLP: Struct holding all data relating to the NLP.
% Outputs:
%   - bolzaCost: Quantity to minimize.
    

    % Extract from inputs.
    intervals    = NLP.intervals;
    LGRDist      = NLP.LGR.dist;
   
    mayorCost    = NLP.cost.mayor;
    lagrangeCost = NLP.cost.lagrange;
      
    rWeights     = NLP.LGR.rWeights;               


    % Extract state and control from decision vector.
    [state, control] = reshapeDecision(decision, NLP);

    stateInitial = state(1, :);
    stateFinal   = state(end, :);

    
    % Calculate scale factors.
    timeInitial  = decision(end-1);
    timeFinal    = decision(end);

    [scaleTime, scaleTau] = timeScale(timeInitial, timeFinal, intervals, LGRDist);


    % Calculate the Mayor cost.
    if mayorCost(stateInitial, stateFinal, timeInitial, timeFinal) ~= 0
        mayorCost = mayorCost(stateInitial, stateFinal, timeInitial, timeFinal);
    else
        mayorCost = 0;
    end
    

    % Calculate Lagrange cost using LGR collocation. Use 'kron' to "clone"
    % the tau scale factor and Radau weights via the Kronecker tensor
    % product. Use these to calculate the LGR weights and then multiply its
    % transpose by the Lagrangian to get the LGR quadrature approximation
    % for the total Lagrange cost.
    weights          = scaleTau.*rWeights;
    if lagrangeCost(state(1:end-1, :), control) ~= 0
        lagrangian       = lagrangeCost(state(1:end-1, :), control);
        lagrangeCost     = scaleTime*weights'*lagrangian;
    else
        lagrangeCost = 0;
    end
    

    % Combine the Mayor and Lagrange costs to get the Bolza cost.
    bolzaCost = mayorCost + lagrangeCost;
end