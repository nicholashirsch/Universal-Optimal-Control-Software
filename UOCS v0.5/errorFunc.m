function [dummyError, error] = errorFunc(decision, NLP)
% Calculates interior and boundary constraints error for given NLP.
% Inputs:
%   - decision: NLP decision vector.
%   - NLP: Struct holding all data relating to the NLP.
% Outputs:
%   - dummyError: Unused dummy output for fmincon to not break.
%   - error: Interior and boundary constraints error.


    % Extract from inputs.
    stateDim             = NLP.dim.state;
      
    intervals            = NLP.intervals;

    LGRDist              = NLP.LGR.dist;
    rPoints              = NLP.LGR.rPoints;
      
    dynamics             = NLP.dynamics;

    nonlinearConstraints = NLP.constraint.nonlinear;

    diffMatrix           = NLP.diffMatrix;


    % Extract state and control from decision vector.
    [state, control] = reshapeDecision(decision, NLP);


    % Calculate scale factors.
    timeInitial  = decision(end-1);
    timeFinal    = decision(end);
    time         = discretize(decision, rPoints, intervals, LGRDist);

    [scaleTime, scaleTau] = timeScale(timeInitial, timeFinal, intervals, LGRDist);


    % Calculate time derivative of the state at LGR points and then use it
    % to perform LGR collocation in order to calculate the interior error.
    stateDot = zeros(length(state)-1, stateDim); % Pre-allocation.
    for ii = 1:length(dynamics)
        stateDot(:, ii) = dynamics{ii}(state(1:end-1, :), control, time(1:end-1));
    end

    interiorError = diffMatrix*state-scaleTime.*scaleTau.*stateDot;
    interiorError = reshape(interiorError, [], 1);


    % Evaluate any additional nonlinear constraints if they exist and then
    % set a dummy linear error.
    if ~isempty(nonlinearConstraints)
        nonlinearError = [];
        for ii = 1:length(nonlinearConstraints)
            nonlinearError = [nonlinearConstraints{ii}(state, control, time); nonlinearError];
        end

        error = [interiorError; nonlinearError];
    else
        error = interiorError;
    end
      
     dummyError = []; % Value is arbitary.
end