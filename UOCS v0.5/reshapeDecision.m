function [state, control] = reshapeDecision(decision, NLP)
% Performs LGR collocation on nonlinear constraints.
% Inputs:
%   - decision: NLP decision vector.
%   - NLP: Struct variable holding all data related to the NLP.
% Outputs:
%   - state: State componenet of current decision vector.
%   - control: Control componenet of current decision vector.

    % Extract from inputs.
    interiorStateDim      = NLP.dim.interiorStateDim;   
    stateDim              = NLP.dim.state;                
    controlDim            = NLP.dim.control;    
    

    % Calculate the discrete state approximation at each of the LGR points in all
    % intervals.
    state = decision(1:(interiorStateDim+2)*stateDim);
    state = reshape(state, [length(state)/stateDim, stateDim]);


    % Now repeat this process for the control.
    control = decision(((interiorStateDim+2)*stateDim+1):end-2);
    control = reshape(control, [length(control)/controlDim, controlDim]);
end