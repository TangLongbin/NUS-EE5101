%% Task-3: Observer Design Based on Pole Placement
function [system, L] = task_3(A, B, C, K)
    % Control poles
    poles = eig(A - B * K);

    % Observer poles
    obs_poles = poles * 5; % Assume the observer poles are 5 times faster than the control poles
    obs_poles = obs_poles'; % Transpose to row vector

    % Calculate the observer gain matrix L
    K_tilde = fullRankPolePlacement(A', C', obs_poles); % Full rank pole placement
    L = K_tilde'; % Observer gain matrix L

    % Construct a extended system with estimated state error
    A_ext = [A - B * K, B * K; zeros(size(A)), A - L * C];
    B_ext = [B; zeros(size(B))];
    Cm = eye(size(A_ext)); % Assume all states are measurable
    Dm = zeros(size(Cm, 1), size(B_ext, 2));
    system = ss(A_ext, B_ext, Cm, Dm); % Extended system

    % Display the L matrix
    disp("L matrix:");
    disp(L);
    
end