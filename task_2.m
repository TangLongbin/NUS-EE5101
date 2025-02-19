%% Task-2: State Feedback Controller Based on LQR
function [system, K] = task_2(A, B, Q, R)
    % Algebraic Riccati Equation (ARE) solution
    Gamma = [A, -B * R^(-1) * B'; -Q, -A']; % Augmented matrix Gamma
    [eigVectors, eigValues] = eig(Gamma); % Eigenvalue decomposition
    eigValues = sum(eigValues); % Diagonal matrix to array
    stableEigvectors= eigVectors(:,real(eigValues)<0); % Select stable eigenvectors

    % Calculate P matrix
    n = size(A, 1); % Number of states
    V = stableEigvectors(1:n, :);
    U = stableEigvectors(n+1:2*n, :);
    P = U * V^(-1);

    % Calculate K matrix
    K = R^(-1) * B' * P; % State feedback gain matrix K
    K = real(K); % Real part of K

    % Closed-loop system
    Cm = eye(size(A)); % Assume all states are measurable
    Dm = zeros(size(Cm, 1), size(B, 2));
    system = ss(A - B * K, B, Cm, Dm);

    % Display the K matrix
    disp("K matrix:");
    disp(K);
    
end
