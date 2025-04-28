function time = discretize(decision, rPoints, intervals, LGRDist)
% Calculates discrete time points corresponding to each of the LGR points.
% Inputs:
%   - TBD
% Outputs:
%   - time: Column vector of discrete time points.


    % Calculate discrete time points.
        timeInitial = decision(end-1);
        timeFinal   = decision(end);
    
        tauInitial  = -1;
        tauFinal    = 1;
        delTau      = (tauFinal-tauInitial)/intervals;
        tauBounds   = (tauInitial:delTau:tauFinal)'; % Form as a column vector.
        
        tau = [];
        for ii = 1:1:length(tauBounds)-1
            if ii > 1
                tauInt = ((rPoints(sum(LGRDist(1:ii-1))+1:sum(LGRDist(1:ii-1))+LGRDist(ii))+1)/2)...
                    .*(tauBounds(ii+1)-tauBounds(ii))+tauBounds(ii);
            else
                tauInt = ((rPoints(1:LGRDist(ii))+1)/2).*(tauBounds(ii+1)-tauBounds(ii))+tauBounds(ii);
            end
            tau    = [tau; tauInt];
        end
        tau  = [tau; 1];
        time = (tau+1)/2*(timeFinal-timeInitial)+timeInitial;
end