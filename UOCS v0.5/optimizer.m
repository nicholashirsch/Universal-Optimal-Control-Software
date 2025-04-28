function [optiTraj, NLP] = optimizer(NLP)
% Optimizer for P-GPOPS. Utilizies fmincon to solve the given NLP using LGR
% collocation.
% Inputs:
%   - NLP: Struct holding all data relating to the NLP.
% Ouputs:
%   - optiTaj: Struct holding all calculated data related to the optimal
%              trajectory which solves the NLP.
%   - NLP: Struct holding all data relating to the NLP, updated to include
%          data added during optimization process.


    % Extract needed information from NLP.                     
    intervals               = NLP.intervals;
    LGRDist                 = NLP.LGR.dist;
                              
    boundaryInitialMin      = NLP.constraint.boundaryInitialMin;
    boundaryInitialMax      = NLP.constraint.boundaryInitialMax;
    boundaryFinalMin        = NLP.constraint.boundaryFinalMin;
    boundaryFinalMax        = NLP.constraint.boundaryFinalMax;
    interiorStateMin        = NLP.constraint.interiorStateMin;
    interiorStateMax        = NLP.constraint.interiorStateMax;
    interiorControlMin      = NLP.constraint.interiorControlMin;
    interiorControlMax      = NLP.constraint.interiorControlMax;
    initialTimeMin          = NLP.constraint.initialTimeMin;
    initialTimeMax          = NLP.constraint.initialTimeMax;
    finalTimeMin            = NLP.constraint.finalTimeMin;
    finalTimeMax            = NLP.constraint.finalTimeMax;
                            
    boundaryInitialDecision = NLP.decision.boundaryInitial;
    boundaryFinalDecision   = NLP.decision.boundaryFinal;
    interiorStateDecision   = NLP.decision.interiorState;
    interiorControlDecision = NLP.decision.interiorControl;
    initialTimeDecision     = NLP.decision.initialTimeDecision; 
    finalTimeDecision       = NLP.decision.finalTimeDecision; 

    
    % Calculate total number of LGR points.
    LGRTotal = sum(LGRDist);


    % Propagate initial guess for interior conditions and then collocate
    % with boundary decision vector and intial and final time to form the
    % initial guess. The collocated initial guess vector will always have
    % the following structure:
    %   - initialState
    %   - interiorState
    %   - finalState
    %   - interiorControl
    %   - initialTime
    %   - finalTime
    interiorStateDim      = LGRTotal-1;
    interiorStateDecision = repmat(interiorStateDecision, interiorStateDim, 1);
    stateDecision         = [boundaryInitialDecision; interiorStateDecision; boundaryFinalDecision];
    stateDecision         = reshape(stateDecision, [], 1);

    interiorControlDim = LGRTotal;
    controlDecision    = repmat(interiorControlDecision, interiorControlDim, 1);
    controlDecision    = reshape(controlDecision, [], 1);

    initialGuess = [stateDecision; controlDecision; initialTimeDecision; finalTimeDecision];


    % Propagate constraints in the same form as with the decision vector
    % into a lower/upper bound format which can then be fed into 'fmincon'.
    interiorStateMin = repmat(interiorStateMin, interiorStateDim, 1);
    interiorStateMax = repmat(interiorStateMax, interiorStateDim, 1);
    stateMin         = [boundaryInitialMin; interiorStateMin; boundaryFinalMin];
    stateMax         = [boundaryInitialMax; interiorStateMax; boundaryFinalMax];
    stateMin         = reshape(stateMin, [], 1);
    stateMax         = reshape(stateMax, [], 1);

    interiorControlMin = repmat(interiorControlMin, interiorControlDim, 1);
    interiorControlMax = repmat(interiorControlMax, interiorControlDim, 1);
    interiorControlMin = reshape(interiorControlMin, [], 1);
    interiorControlMax = reshape(interiorControlMax, [], 1);
    

    decisionMin = [stateMin; interiorControlMin; initialTimeMin; finalTimeMin];
    decisionMin = reshape(decisionMin, [], 1);
    decisionMax = [stateMax; interiorControlMax; initialTimeMax; finalTimeMax];
    decisionMax = reshape(decisionMax, [], 1);

    
    % Calculate Radau points and weights.
    rPoints  = radauPoints(LGRDist);

    rWeights = radauWeights(rPoints, LGRDist);
    rWeights = reshape(rWeights, [], 1);


    % Form the differentiation matrix.
    diffMatrix = [];
    for ii = 1:length(LGRDist)
        if ii > 1
            diffMatrixInterval = collocD([rPoints(sum(LGRDist(1:ii-1))+1:sum(LGRDist(1:ii-1))+LGRDist(ii)); 1]);
            diffMatrixInterval(end, :) = [];

            diffMatrix(yStart+1:yStart+size(diffMatrixInterval, 1), xStart:xStart+size(diffMatrixInterval, 2)-1)...
                = diffMatrixInterval;
        else
            diffMatrixInterval = collocD([rPoints(1:LGRDist(ii)); 1]);
            diffMatrixInterval(end, :) = [];

            diffMatrix(1:size(diffMatrixInterval, 1), 1:size(diffMatrixInterval, 2)) ...
                = diffMatrixInterval;
        end
        [yStart, xStart] = size(diffMatrix);
    end
    diffMatrix = sparse(diffMatrix);


    % Add any new information to NLP in order to make passing variables
    % between functions easier.
    NLP.LGR.rPoints            = rPoints;
    NLP.LGR.rWeights           = rWeights;
    NLP.LGR.total              = LGRTotal;

    NLP.dim.interiorStateDim   = interiorStateDim;
    NLP.dim.interiorControlDim = interiorControlDim;

    NLP.diffMatrix             = diffMatrix;


    % Call fmincon to optimize the NLP.
    settings = optimoptions('fmincon', 'Display', 'iter', ...
        'Diagnostics', 'on', 'TolX', 1e-8, 'TolFun', 1e-8, 'Algorithm', ...
        'interior-point',  'EnableFeasibilityMode', true, ...
        'SubproblemAlgorithm', 'cg', 'MaxFunctionEvaluations', 1e6, ...
        'MaxIterations', 1e5); % Settings for fmincon.
    decision = fmincon(@objFunc, initialGuess, [], [], [], [], ...
        decisionMin, decisionMax, @errorFunc, settings, NLP);
    

    % Extract state, control, and time from decision vector.
    [state, control] = reshapeDecision(decision, NLP);
    time = discretize(decision, rPoints, intervals, LGRDist);
    

    % Calculate error in results.
    [~, error] = errorFunc(decision, NLP);


    % Package and return results
    optiTraj.state    = state;
    optiTraj.control  = control;
    optiTraj.time     = time;
    optiTraj.error    = error;
end