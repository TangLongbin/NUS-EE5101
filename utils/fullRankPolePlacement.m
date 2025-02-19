% fullRankPolePlacement - Computes the state feedback gain matrix K for a given system
% using full rank pole placement method.
%
% Syntax: K = fullRankPolePlacement(A, B, desired_poles)
%
% Inputs:
%   A - State matrix of the system (n x n)
%   B - Input matrix of the system (n x m)
%   desired_poles - Desired closed-loop poles (1 x n)
%
% Outputs:
%   K - State feedback gain matrix (m x n)
%
% Example:
%   A = [0 1; -2 -3];
%   B = [0; 1];
%   desired_poles = [-1, -2];
%   K = fullRankPolePlacement(A, B, desired_poles);
%
% This function performs the following steps:
% 1. Checks the controllability of the system.
% 2. Selects n linearly independent columns from the controllability matrix.
% 3. Constructs the control transformation matrix T.
% 4. Computes the transformed system matrices A_bar and B_bar.
% 5. Designs the desired closed-loop system matrix Ad using the desired poles.
% 6. Solves for the feedback gain matrix K_bar in the transformed coordinates.
% 7. Transforms K_bar back to the original coordinates to obtain K.
function K = fullRankPolePlacement(A, B, desired_poles)
    assert(size(A, 1) == size(A, 2), "A must be a square matrix!");
    assert(size(B, 1) == size(A, 1), "The number of rows in B must be equal to the number of columns in A!");
    assert(length(desired_poles) == size(A, 1), "The number of desired poles must be equal to the number of states!");

    % Get the dimensions of the system
    n = size(B, 1); % Number of states
    m = size(B, 2); % Number of inputs

    % Check the controllability of the system
    Wc = B;
    for i = 1:n-1
        Wc = [B, A * Wc];
    end
    assert(rank(Wc) == size(Wc, 1), "The system is not controllable!");
    
    % Select n linearly independent columns of Wc
    selected_cols = [];
    for col_idx = 1:size(Wc, 2)
        % Try to add the current column
        current_cols = Wc(:, selected_cols); % Already selected columns
        current_cols = [current_cols, Wc(:, col_idx)];

        % Check if the current selected columns are linearly independent
        if rank(current_cols) == size(current_cols, 2)
            % If linearly independent, add the current column to selected_cols
            selected_cols = [selected_cols, col_idx];
        end

        % Stop if the number of selected columns reaches n
        if length(selected_cols) == n
            break;
        end
    end

    % Construct matrix Ctrl Matrix by rearranging the selected columns
    CtrlMatrix = [];  % Initialize Ctrl Matrix
    di = [];  % Number of independent columns corresponding to each input vector bi
    % Iterate over each input vector bi
    for i = 1:m
        % Get all columns in selected_cols that belong to bi
        di_indices = selected_cols(mod(selected_cols - 1, m) + 1 == i);
        di = [di, length(di_indices)]; % Record the number of independent columns

        % Fill these columns into the C matrix in order
        CtrlMatrix = [CtrlMatrix, Wc(:, di_indices)];
    end

    % Control Transformation Matrix T
    T = []; % Initialize T
    CtrlMatrix_inv = inv(CtrlMatrix); % Inverse of the Ctrl Matrix
    idx = 0; % Index of the selected row in the inversed Ctrl Matrix
    for i = 1:m
        % Prefix sum of di
        idx = idx + di(i);
        q = CtrlMatrix_inv(idx, :); % Get the selected row q
        % Add selected row q multipled by A^(j-1) to T
        for j = 1:di(i)
            T = [T; q]; % Add q*A^(j-1) to T
            q = q * A; % Multiply q by A
        end
    end

    % Calculate A_bar, B_bar and K_bar
    A_bar = T * A * inv(T);
    B_bar = T * B;
    A_bar = round(A_bar, 6); % Round to 6 decimal places to make small values zero
    B_bar = round(B_bar, 6); % Round to 6 decimal places to make small values zero
    K_bar = sym('k', [m, n]); % To be determined

    % Design Ad blocks using desired poles
    Ad = zeros(n, n); % Initialize Ad
    idx = 1; % Index of the desired poles
    % Fill a controllable canonical form block, the size of which is di(i)*di(i)
    for i = 1:m
        % Get the denominator coefficients
        den_coeff = poly(desired_poles(idx: idx+di(i)-1));
        % Fill the Ad block
        Ad(idx: idx+di(i)-2, idx+1: idx+di(i)-1) = eye(di(i)-1); % Fill the upper right part with identity matrix
        Ad(idx+di(i)-1, idx: idx+di(i)-1) = -den_coeff(end:-1:2); % Fill the last row with the denominator coefficients
        idx = idx + di(i); % Update the index
    end

    % Calculate the feedback gain K_bar and K
    equation = A_bar - B_bar*K_bar == Ad;
    solution = solve(equation, K_bar);
    K_bar = double(struct2array(solution));
    K_bar = reshape(K_bar, m, n);
    K = K_bar * T;
end