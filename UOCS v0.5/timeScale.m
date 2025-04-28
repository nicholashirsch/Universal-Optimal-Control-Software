function [scaleTime, scaleTau] = timeScale(timeInitial, timeFinal, intervals, LGRDist)
% Calculates time and tau scale factors for us in LGR collocation.
% Inputs:
%   - TBD
% Outputs:
%   - scaleTime: Time scale factor.
%   - scaleTau: Kronecker tensor product propagated tau scale factor.

    % Calculate time scaling factor.
    scaleTime  = (timeFinal-timeInitial)/2;

    
    % Define scale time, tau, and calculate the endpoints of the tau
    % intervals that make up the time interval.
    tauInitial = -1;
    tauFinal   = 1;
    delTau     = (tauFinal-tauInitial)/intervals;
    tau        = (tauInitial:delTau:tauFinal)'; % Form as a column vector.
    tau        = [tau(1:end-1) tau(2:end)]; % Stack endpoints of intervals.


    % Calculate tau scaling factors.
    scaleTau     = (tau(:, 2)-tau(:, 1))/2;
    scaleTauProp = [];
    for ii = 1:length(LGRDist)
        scaleTauProp = [scaleTauProp; scaleTau(ii)*ones(LGRDist(ii), 1)]; % Propgate tau-scale factor.
    end
    scaleTau = scaleTauProp;
end