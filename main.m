%% Mini Project of EE5101
% Author: Tang Longbin
% ID: A0298466H
% Email: longbin@u.nus.edu

%% Clean up
clc;
clear;
close all;

%% Add path and load configuration
addpath('utils');
config;

%% Task-1: State Feedback Controller Based on Pole Placement
if runTask.task_1
    % Desired poles calculation
    [p1, p2] = secondOrderPoles(overshoot, settling_time, delta_zeta, delta_w_n); % Dominant poles
    p3 = 10 * min(real(p1), real(p2)); % Undominant pole
    disp("Desired Poles: " + p1 + ", " + p2 + ", " + p3);
    desired_poles = [p1, p2, p3];

    % Pole placement
    [system, K] = task_1(A, B, desired_poles);

    % Closed-loop system response
    responseVisualization(system, x_0); % Response visualization

    % Simulink Simulation
    if RunSim
        runSimulink(stateFeedback_model_path, scope_name, sim_time, OpenSimGUI, CloseAfterSim);
    end
end

%% Task-2: State Feedback Controller Based on LQR
if runTask.task_2
    % Q, R setting
    Q = [1 0 0;
        0 1 0;
        0 0 100]; % State weight matrix Q
    R = [1 0;
        0 20]; % Control weight matrix R

    % LQR ARE Calculation
    [system, K] = task_2(A, B, Q, R); % State feedback gain matrix K

    % Closed-loop system response
    responseVisualization(system, x_0); % Response visualization

    % Simulink Simulation
    if RunSim
        runSimulink(stateFeedback_model_path, scope_name, sim_time/30, OpenSimGUI, CloseAfterSim);
    end
end

%% Task-3: LQR State Feedback Controller with Observer
if runTask.task_3
    % Q, R setting
    Q = [1 0 0;
        0 1 0;
        0 0 100]; % State weight matrix Q
    R = [1 0;
        0 20]; % Control weight matrix R
    
    % Calculate the LQR state feedback gain matrix K
    [~, K] = task_2(A, B, Q, R);

    % Create a LQR controller with observer
    [system, L] = task_3(A, B, C, K);

    % Response visualization
    x0_ext = [x_0; x_0]; % Initial state
    responseVisualization(system, x0_ext); % Response visualization

    % Simulink Simulation
    if RunSim
        runSimulink(observerStateFeedback_model_path, scope_name, sim_time/30, OpenSimGUI, CloseAfterSim);
    end
end

%% Task-4: State Feedback Decoupling Controller
if runTask.task_4
    % Desired poles
    pole = -1;
    desired_poles = repmat(pole, 1, size(C, 1));

    % Decoupling controller with desired poles
    [system, K, F] = task_4(A, B, C, desired_poles);

    % Response visualization
    responseVisualization(system, x_0);

    % Simulink Simulation
    if RunSim
        runSimulink(decoupleControl_model_path, scope_name, sim_time, OpenSimGUI, CloseAfterSim);
    end

end

%% Task-5: Servo Control with Step Disturbance Rejection
if runTask.task_5
    % Extend the system with output error as new states
    A_bar = [A, zeros(size(A, 1), size(C, 1));
            -C, zeros(size(C, 1))];
    B_bar = [B; zeros(size(C, 1), size(B, 2))];

    % Calculate the LQR state feedback gain matrix K
    Q = [1 0 0 0 0;
        0 100 0 0 0;
        0 0 100 0 0;
        0 0 0 100 0;
        0 0 0 0 100]; % State weight matrix Q
    R = [1 0;
        0 20]; % Control weight matrix R
    [~, K] = task_2(A_bar, B_bar, Q, R);
    K1 = K(:, 1:size(A, 1));
    K2 = K(:, size(A, 1)+1:end);

    % Calculate the observer gain matrix L
    [~, L] = task_3(A, B, C, K1);

    % Closed-loop system with LQR and observer
    system = task_5(A, B, C, K1, K2, L);
    
    % Response visualization
    x0_ext = [x_0; zeros(size(C, 1), 1); x_0]; % Initial state
    responseVisualization(system, x0_ext); % Response visualization
    setPointResponse(system, r, sim_time); % Set point response
    
    % Simulink Simulation
    if RunSim
        runSimulink(servoControl_model_path, scope_name, sim_time/2, OpenSimGUI, CloseAfterSim);
    end

end

%% Task-6: States Servo Control
if runTask.task_6
    Cm = eye(size(A, 1)); % Assume all states are measurable
    % Extend the system with output error as new states
    A_bar = [A, zeros(size(A, 1), size(Cm, 1));
            -Cm, zeros(size(Cm, 1))];
    B_bar = [B; zeros(size(Cm, 1), size(B, 2))];
    
    % Calculate the LQR state feedback gain matrix K
    Q = [1 0 0 0 0 0;
        0 1 0 0 0 0;
        0 0 1 0 0 0;
        0 0 0 100 0 0;
        0 0 0 0 100 0;
        0 0 0 0 0 100]; % State weight matrix Q
    R = [1 0;
        0 1]; % Control weight matrix R
    [~, K] = task_2(A_bar, B_bar, Q, R);
    K1 = K(:, 1:size(A, 1));
    K2 = K(:, size(A, 1)+1:end);

    % Closed-loop system with LQR and observer
    W = diag([a+b+1, c+4, d+5]); % Weight matrix for set point
    [system, x_s] = task_6(A, B, Cm, K1, K2, W, x_ref);
    
    % Response visualization
    x0_ext = [x_0; zeros(size(Cm, 1), 1)]; % Initial state
    responseVisualization(system, x0_ext); % Response visualization
    setPointResponse(system, x_s, sim_time/3, x0_ext); % Set point response
    
    % Simulink Simulation
    if RunSim
        runSimulink(servoStateControl_model_path, scope_name, sim_time/3, OpenSimGUI, CloseAfterSim);
    end

end