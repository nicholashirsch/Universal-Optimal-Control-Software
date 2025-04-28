% Template to use when creating an NLP to solve in UOCS.
% Outputs:
%   - NLP: A struct variable containing all the information nessecary to
%          define and solve a nonlinear programming problem using UOCS.
    
    
    % Set any additional functions and constants for use in setting up the
    % NLP.
    %
    

    % Perform basic dimensioning of the state and control for the problem.
    % All decision and constraint vectors must match these dimensions.
    stateDim   = 100;
    controlDim = 100;


    % Set solver settings to use when attempting to solve the NLP,
    % including the number of intervals and the number of LGR points
    % desired in each interval.
    intervals = 3;
    % interval:  1  2  3  4  5  6  7  8  9  10 ...
    LGRDist   = [40 30 30];


    % Define the state and the initial and final times, if a component at
    % either time is unknown simply make a guess for it; this will be used
    % as the guesses for the boundary decision. The initial
    % guess for the interior conditions must also be set for both the state
    % and the control component-wise. Finally, guess or input the initial
    % and final times.
    boundaryInitialDecision    = [x10 x20 x30 --- xn0];
    boundaryFinalDecision      = [x1f x2f x3f --- xnf];

    interiorStateDecision      = [x1  x2  x3  --- xn];
    interiorControlDecision    = [u1  u2  u3  --- un];

    initialTimeDecision        = t0;
    finalTimeDecision          = tf;

    
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
    boundaryInitialMin = [x10 x20 x30 --- xn0];
    boundaryInitialMax = [x10 x20 x30 --- xn0];
    
    interiorStateMin   = [x1  x2  x3  --- xn];
    interiorStateMax   = [x1  x2  x3  --- xn];
  
    boundaryFinalMin   = [x1f x2f x3f --- xnf];
    boundaryFinalMax   = [x1f x2f x3f --- xnf];


    % Formulate path constraints for all discrete control using the same
    % form as with the states.
    interiorControlMin  = [u1  u2  u3  --- un];
    interiorControlMax  = [u1  u2  u3  --- un];


    % Formulate boundary constraints on time using the same format as for
    % state boundary constraints.
    initialTimeMin    = t0;
    initialTimeMax    = t0;
    finalTimeMin      = tf;
    finalTimeMax      = tf;


    % Define the dynamics (the derivative of the state vector) as a cell
    % array with the same number of components as the state. Each component
    % of the array should be an inline function of the state, control, and time.
    dynamics = {
        @(state, control, time) stateDot1
        @(state, control, time) stateDot2
        % ...
        @(state, control, time) stateDotNx
    };


    % Define the Mayor and Lagrange costs which will comprise the Bolza
    % cost function. If either doesn't exist simply set the cost equal to
    % 0.
    mayorCost    = @(stateInitial, stateFinal, timeInitial, timeFinal) M;
    lagrangeCost = @(state, control) L;


    % Define any additional nonlinear constraints. This includes equality
    % path and boundary constraints which are functions as opposed to
    % constants. If no constraints exist simply leave empty.
    nonlinearConstraints = {
        @(state, control, time) nonlinearConstraint1
        @(state, control, time) nonlinearConstraint2
     };


    % Package all given information into a single struct variable and pass
    % this to P-GPOPS.
    NLP.dim.state                     = stateDim;
    NLP.dim.control                   = controlDim;

    NLP.intervals                     = intervals;
    NLP.LGR.dist                      = LGRdist;
             
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