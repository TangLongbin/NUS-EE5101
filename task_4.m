%% Task-4: State Feedback Decoupling Controller
function [system, K, F] = task_4(A, B, C, desired_poles)
    % Characteristic polynomial

    % Relative degree
    m = size(C, 1);
    n = size(C, 2);
    sigma = zeros(m, 1);
    B_star = [];
    C_star = [];
    for i = 1:m
        c_i = C(i, :); % i-th row of C
        Am = eye(n); % A^0
        for j = 1:n
            if any(c_i * Am * B)
                sigma(i) = j; % sigma(i) = j if c_i * A^(j-1) * B != 0
                B_star = [B_star; c_i * Am * B]; % Update B_star

                % Desired poles
                poles = repmat(desired_poles(i), 1, j);
                poly_coeff = poly(poles); % Characteristic polynomial
                C_star = [C_star; c_i * matrixPolynomial(A, poly_coeff)]; % Update C_star
                break;
            end
            Am = Am * A; % A^(j-1)
        end
    end
    
    % State feedback decoupling, u = -Kx + Fr
    F = B_star^(-1);
    K = F * C_star; % Decoupling controller
    
    % Closed-loop system
    Cm = eye(size(A)); % Assume all states are measurable
    Dm = zeros(size(Cm, 1), size(B, 2));
    system = ss(A - B * K, B * F, Cm, Dm);

    % Display the K and F matrix
    disp("K matrix:");
    disp(K);
    disp("F matrix:");
    disp(F);

end