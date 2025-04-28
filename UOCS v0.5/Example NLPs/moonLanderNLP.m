% Moon Lander Problem
% Outputs:
%   - NLP: A struct variable containing all the information nessecary to
%          define and solve a nonlinear programming problem using P-GPOPS.
    
    
    % Set any additional functions and constants for use in setting up the
    % NLP.
    GRAV_PARAM = 1.5;


    % Perform basic dimensioning of the state and control for the problem.
    % All decision and constraint vectors must match these dimensions.
    stateDim   = 2;
    controlDim = 1;


    % Set solver settings to use when attempting to solve the NLP,
    % including the number of intervals and the initial number of LGR
    % points to use in collocation.
    intervals = 3;
    % interval:  1  2  3  4  5  6  7  8  9  10 ...
    LGRDist   = [10 10 10];


    % Define the state and the initial and final times, if a component at
    % either time is unknown simply make a guess for it; this will be used
    % as the guesses for the boundary decision. The initial
    % guess for the interior conditions must also be set for both the state
    % and the control component-wise. Finally, guess or input the initial
    % and final times.
    boundaryInitialDecision    = [10 -2];
    boundaryFinalDecision      = [0 0];

    interiorStateDecision      = [0 0];
    interiorControlDecision    = 3;

    initialTimeDecision        = 0;
    finalTimeDecision          = 4;

    
    % Formulate path and boundary constraints for all discrete states.
    % Boundary constraints are to be represented as path constraints of the
    % form:
    %   b0 <= Z(1) <= b0
    % and path constraints of the form:
    %   xMin <= Z(n) <= xMax
    % For unknown boundary and path constraints use the format:
    %   -Inf <= Z(n) <= inf
    % Note that if the state has multiple components constraints may be
    % applied component-wise as follows:
    %   [-Inf -Inf x3Min] <= [Z(n)1 Z(n)2 Z(n)3] <= [x1Max x2Max inf]
    boundaryInitialMin = [10 -2];
    boundaryInitialMax = [10 -2];
    
    interiorStateMin   = [-inf -inf];
    interiorStateMax   = [inf inf];
  
    boundaryFinalMin   = [0 0];
    boundaryFinalMax   = [0 0];


    % Formulate path constraints for all discrete control using the same
    % form as with the states.
    interiorControlMin  = 0;
    interiorControlMax  = 3;


    % Formulate boundary constraints on time using the same format as for
    % state boundary constraints.
    initialTimeMin    = 0;
    initialTimeMax    = 0;
    finalTimeMin      = 0;
    finalTimeMax      = inf;


    % Define the dynamics (the derivative of the state vector) as a cell
    % array with the same number of components as the state. Each component
    % of the array should be an inline function of the state and control.
    dynamics = {
        @(state, control, time) state(:, 2)
        @(state, control, time) -GRAV_PARAM+control
    };


    % Define the Mayor and Lagrange costs which will comprise the Bolza
    % cost function. If either doesn't exist simply set the cost equal to
    % 0.
    mayorCost    = @(stateInitial, stateFinal, timeInitial, timeFinal) 0;
    lagrangeCost = @(state, control) control;


    % Define any additional nonlinear constraints. This includes equality
    % path and boundary constraints which are functions as opposed to
    % constants. If no constraints exist simply set equal to 0.
    nonlinearConstraints = {
        
     };


    % Package all given information into a single struct variable and pass
    % this to P-GPOPS.
    NLP.dim.state                     = stateDim;
    NLP.dim.control                   = controlDim;

    NLP.intervals                     = intervals;
    NLP.LGR.dist                      = LGRDist;
             
    NLP.cost.mayor                    = mayorCost;
    NLP.cost.lagrange                 = lagrangeCost;

    NLP.dynamics                      = dynamics;
        
    NLP.constraint.boundaryInitialMin = boundaryInitialMin;
    NLP.constraint.boundaryInitialMax = boundaryInitialMax;
    NLP.constraint.boundaryFinalMin   = boundaryFinalMin;
    NLP.constraint.boundaryFinalMax   = boundaryFinalMax;
    NLP.constraint.interiorStateMin   = interiorStateMin;
    NLP.constraint.interiorStateMax   = interiorStateMax;
    NLP.constraint.interiorControlMin = interiorControlMin;
    NLP.constraint.interiorControlMax = interiorControlMax;
    NLP.constraint.initialTimeMin     = initialTimeMin;
    NLP.constraint.initialTimeMax     = initialTimeMax;
    NLP.constraint.finalTimeMin       = finalTimeMin;
    NLP.constraint.finalTimeMax       = finalTimeMax;
    NLP.constraint.nonlinear          = nonlinearConstraints;
     
    NLP.decision.boundaryInitial      = boundaryInitialDecision;
    NLP.decision.boundaryFinal        = boundaryFinalDecision;
    NLP.decision.interiorState        = interiorStateDecision;
    NLP.decision.interiorControl      = interiorControlDecision;
    NLP.decision.initialTimeDecision  = initialTimeDecision;
    NLP.decision.finalTimeDecision    = finalTimeDecision;