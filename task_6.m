%% Task-6: States Servo Control
function [system, x_s] = task_6(A, B, C, K1, K2, W, x_ref)
    % Construct a extended system with estimated state error
    A_ext = [A - B * K1, -B * K2; 
            -C, zeros(size(C, 1))];
    B_ext = [zeros(size(C')); eye(size(C, 1))];
    % C_ext = eye(size(A_ext)); % Assume all states are measurable
    C_ext = [eye(size(A)), zeros(size(A, 1), size(C, 1))];
    D_ext = zeros(size(C_ext, 1), size(B_ext, 2));
    system = ss(A_ext, B_ext, C_ext, D_ext); % Extended system

    % Least square solution for the set point for minimizing J(x_s) = 1/2 * (x_s-x_ref)' * W * (x_s-x_ref)
    u = -(B' * A'^(-1) * W * A^(-1) * B) \ (B' * A'^(-1)* W * x_ref); % u = -[B^T (A^T)^{-1} W A^{-1} B]^{-1} B^T (A^T)^{-1} W x_{sp}
    x_s = -A^(-1) * B *u;

    % Display the set point
    disp("Set point:");
    disp(x_s);
end