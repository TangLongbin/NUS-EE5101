%% Task-1: State Feedback Controller Based on Pole Placement
function [system, K] = task_1(A, B, desired_poles)
    % Use full rank pole placement to calculate the state feedback gain matrix K
    K = fullRankPolePlacement(A, B, desired_poles);

    % Closed-loop system
    Cm = eye(size(A)); % Assume all states are measurable
    Dm = zeros(size(Cm, 1), size(B, 2));
    system = ss(A - B * K, B, Cm, Dm);

    % Display the state feedback gain matrix K
    disp("State Feedback Gain Matrix (K):");
    disp(K);
end
