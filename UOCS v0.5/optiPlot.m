function optiPlot(time, state, control, plotSettings)
% Plots optimization results for given NLP based on the settings given.
% Inputs:
%   - TBD
% Outputs:
%   - Requested plots based on 'plotSettings'.
  
% NOTE: This function is currently a mess. It will be cleaned up and
%       properly commented in the future.
  

    % Plot optimal state components in a tiled layout.
    if plotSettings(1) == true
        figure
        tiles = tiledlayout("flow"); % Individual optimal states.
        for ii = 1:size(state, 2)
            nexttile
            
            plot(time, state(:, ii), '-o') % Where state is actually plotted.
        
            stateLabelDynamic{ii} = ['$x_' num2str(ii) '(t)$'];
            timeLabel   = xlabel('$t$');
            stateLabel  = ylabel(stateLabelDynamic{ii});
            legendLabel = legend(stateLabelDynamic{ii});
        
            set(timeLabel,'Interpreter','LaTeX','FontSize',16);
            set(stateLabel,'Interpreter','LaTeX','FontSize',16);
            set(legendLabel,'Interpreter','LaTeX','FontSize',16);
            set(gca,'TickLabelInterpreter','LaTeX','FontSize',14);
            grid on
        end
    end
    
    
    % Plot optimal control components in a tiled layout.
    if plotSettings(2) == true
        figure
        tiles = tiledlayout("flow"); % Individual optimal controls.
        for jj = 1:size(control, 2)
            nexttile
            plot(time(1:end-1), control(:, jj), '-o')
        
            controlLabelDynamic{jj} = ['$u_' num2str(jj) '(t)$'];
            timeLabel    = xlabel('$t$');
            controlLabel = ylabel(controlLabelDynamic{jj});
            legendLabel  = legend(controlLabelDynamic{jj});
        
            set(timeLabel,'Interpreter','LaTeX','FontSize',16);
            set(controlLabel,'Interpreter','LaTeX','FontSize',16);
            set(legendLabel,'Interpreter','LaTeX','FontSize',16);
            set(gca,'TickLabelInterpreter','LaTeX','FontSize',14);
            grid on
        end
    end
    
    
    % Plot optimal state components all in one graph.
    if plotSettings(3) == true
        if size(state, 2) > 1
            figure % All states on one graph.
            plot(time, state, '-o')
            timeLabel   = xlabel('$t$');
            stateLabelDynamic{1} = ['$x_' num2str(1) '(t)$'];
            stateLabel = stateLabelDynamic{1};
            for kk = 2:size(state, 2)
                stateLabelDynamic{kk} = ['$x_' num2str(kk) '(t)$'];
                stateLabel = [stateLabel ', ' stateLabelDynamic{kk}];
            end
            timeLabel   = xlabel('$t$');
            stateLabel  = ylabel(stateLabel);
            legendLabel = legend(stateLabelDynamic);
            set(timeLabel,'Interpreter','LaTeX','FontSize',16);
            set(stateLabel,'Interpreter','LaTeX','FontSize',16);
            set(legendLabel,'Interpreter','LaTeX','FontSize',16);

            set(gca,'TickLabelInterpreter','LaTeX','FontSize',14);
            grid on
        end
    end
    

    % Plot optimal control components all in one graph.
    if plotSettings(4) == true
        if size(control, 2) > 1
            figure % All states on one graph.
            plot(time(1:end-1), control, '-o')
            timeLabel   = xlabel('$t$');
            controlLabelDynamic{1}  = ['$u_' num2str(1) '(t)$'];
            controlLabel = controlLabelDynamic{1};
            for ll = 2:size(control, 2)
                controlLabelDynamic{ll} = ['$u_' num2str(ll) '(t)$'];
                controlLabel = [controlLabel ', ' controlLabelDynamic{ll}];
            end
            timeLabel     = xlabel('$t$');
            controlLabel  = ylabel(controlLabel);
            legendLabel   = legend(controlLabelDynamic);
            set(timeLabel,'Interpreter','LaTeX','FontSize',16);
            set(controlLabel,'Interpreter','LaTeX','FontSize',16);
            set(legendLabel,'Interpreter','LaTeX','FontSize',16);

            set(gca,'TickLabelInterpreter','LaTeX','FontSize',14);
        grid on
        end
    end
end