% UOCS Executive Function


% Initialization
clear; clc;


% Print UI and request NLP definition file. NOTE: The ASCI title art is
% fine, it just looks weird because '\\' has to be used to print '\'
% without having to call 'sprintfw'.
fprintf('______________________________________________________\n')
fprintf('   __  __ ____   ______ _____\n')
fprintf('  / / / // __ \\ / ____// ___/\n')
fprintf(' / / / // / / // /     \\__ \\ \n')
fprintf('/ /_/ // /_/ // /___  ___/ / \n')
fprintf('\\____/ \\____/ \\____/ /____/  \n')
fprintf('\n')
fprintf('\t\t\t\t\t\t   NICHOLAS HIRSCH\n')
fprintf('\t\t\t\t\t\t   UNIVERSITY OF FLORIDA, 2024\n')
fprintf('\t\t\t\t\t\t   v0.5\n')
fprintf('______________________________________________________\n')
fprintf('\n')

fprintf('Please provide the requisite file for the desired NLP.\n')
fprintf('Alternatively, type "EXAMPLES", to choose from a list of inbuilt problems.\n\n')
NLPFile = input('NLP: ');

if NLPFile == "EXAMPLES"
    fprintf('\nWhich example would you like to run?.\n')
    fprintf('\t 1 - Hyper-Sensitive Problem\n')
    fprintf('\t 2 - Brahistochrone Problem (DISABLED)\n')
    fprintf('\t 3 - Linear Tangent Steering Problem (DISABLED)\n')
    fprintf('\t 4 - Ground Mobile Robot Problem (DISABLED)\n')
    fprintf('\t 5 - Bryson-Denham Problem\n')
    fprintf('\t 6 - Moon Lander Problem\n')
    fprintf('\t 7 - Orbit Raising Problem (DISABLED)\n')
    fprintf('\t 8 - Robot Arm Problem\n')
    fprintf('\t 9 - Supersonic Time to Climb Problem (DISABLED)\n\n')

    example = input('Example: ');

    switch  example % Select NLP to run based on user input.
        case 1
            NLPFile = "hyperSensitiveNLP.m";
        case 2
            NLPFile = "brachistochroneNLP.m"
        case 3
            NLPFile = "linearTangentSteeringNLP.m";
        case 4
            NLPFile = "groundMobileRobotNLP.m";
        case 5
            NLPFile = "brysonDenhamNLP.m";
        case 6
            NLPFile = "moonLanderNLP.m";
        case 7
            NLPFile = "orbitRaisingNLP.m";
        case 8
            NLPFile = "robotArmNLP.m";
        case 9
            NLPFILE = "supersonicClimbNLP.m";
    end
end

run(NLPFile);


% Optimization of the NLP.
[optiTraj, NLP] = optimizer(NLP);


% Packaged results.
state   = optiTraj.state;
control = optiTraj.control;
time    = optiTraj.time;
error   = optiTraj.error;


% Plot results if requested as determined by the plot settings below. The
% vector 'plotSettings' is a logical double where a 1 enables plotting of
% the plot associated with the corresponding index, as listed below:
%   1 - Plot states in tiled layout.
%   2 - Plot control in tiled layout.
%   3 - Plot states against each other (there must be two or more states).
%   4 - Plot controls against each other (there must be two or more controls).

%               1 2 3 4
plotSettings = [1 1 0 0];

close all
optiPlot(time, state, control, plotSettings)