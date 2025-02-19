%% Task-5: Servo Control with Step Disturbance Rejection
function system = task_5(A, B, C, K1, K2, L)
    % Construct a extended system with estimated state error
    A_ext = [A - B * K1, -B * K2, -B * K1; 
        -C, zeros(size(C, 1)), zeros(size(C));
        zeros(size(A)), zeros(size(B)), A - L * C];
    B_ext = [zeros(size(B)); eye(size(C, 1)); zeros(size(B))];
    % Cm = eye(size(A_ext)); % Assume all states are measurable
    Cm = [C, zeros(size(C, 1)), zeros(size(C))]; % Assume only the output is measurable
    Dm = zeros(size(Cm, 1), size(B_ext, 2));
    system = ss(A_ext, B_ext, Cm, Dm); % Extended system

end