% Hyper-Sensitive Problem
% Outputs:
%   - NLP: A struct variable containing all the information nessecary to
%          define and solve a nonlinear programming problem using P-GPOPS.
    
    
    % Set any additional functions and constants for use in setting up the
    % NLP.
    %
    
    
    % Perform basic dimensioning of the state and control for the problem.
    % All decision and constraint vectors must match these dimensions.
    stateDim   = 1;
    controlDim = 1;


    % Set solver settings to use when attempting to solve the NLP,
    % including the number of intervals and the initial number of LGR
    % points to use in collocation.
    intervals = 100;
    % interval:  1  2  3  4  5  6  7  8  9  10 ...
    LGRDist   = [25 ones(1, 98) 25];


    % Define the state and the initial and final times, if a component at
    % either time is unknown simply make a guess for it; this will be used
    % as the guesses for the boundary decision. The initial
    % guess for the interior conditions must also be set for both the state
    % and the control component-wise. Finally, guess or input the initial
    % and final times.
    boundaryInitialDecision    = 1.5;
    boundaryFinalDecision      = 1;

    interiorStateDecision      = 0;
    interiorControlDecision    = 0;

    initialTimeDecision        = 0;
    finalTimeDecision          = 1000;

    
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
    boundaryInitialMin = 1.5;
    boundaryInitialMax = 1.5;
    
    interiorStateMin   = -inf;
    interiorStateMax   = inf;
  
    boundaryFinalMin   = 1;
    boundaryFinalMax   = 1;


    % Formulate path constraints for all discrete control using the same
    % form as with the states.
    interiorControlMin  = -inf;
    interiorControlMax  = inf;


    % Formulate boundary constraints on time using the same format as for
    % state boundary constraints.
    initialTimeMin    = 0;
    initialTimeMax    = 0;
    finalTimeMin      = 1000;
    finalTimeMax      = 1000;


    % Define the dynamics (the derivative of the state vector) as a cell
    % array with the same number of components as the state. Each component
    % of the array should be an inline function of the state and control.
    dynamics = {
        @(state, control, time) -state.^3 + control
    };


    % Define the Mayor and Lagrange costs which will comprise the Bolza
    % cost function. If either doesn't exist simply set the cost equal to
    % 0.
    mayorCost    = @(stateInitial, stateFinal, timeInitial, timeFinal) 0;
    lagrangeCost = @(state, control) 0.5*(state.^2+control.^2);


    % Define any additional nonlinear constraints. This includes equality
    % path and boundary constraints which are functions as opposed to
    % constants. If no constraints exist simply leave empty.
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