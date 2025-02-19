% responseVisualization Visualizes the step and initial condition responses of a system.
%
%   responseVisualization(system, Initial_state) plots the step response and
%   initial condition response of the given system with the specified initial state.
%
%   responseVisualization(system, Initial_state, ShowResponse, ShowInitialResponse)
%   allows you to specify whether to show the step response and/or the initial
%   condition response.
%
%   Arguments:
%       system - The system to be analyzed (LTI system).
%       Initial_state - The initial state vector for the system.
%       ShowResponse - (Optional) Boolean flag to show the step response. Default is true.
%       ShowInitialResponse - (Optional) Boolean flag to show the initial condition response. Default is true.
%
%   Example:
%       sys = ss(A, B, C, D); % Define your state-space system
%       x0 = [1; 0; 0]; % Initial state
%       responseVisualization(sys, x0);
%
%   This function generates two figures:
%       1. Step Response: Shows the step response of the closed-loop system with
%          peak response and settling time characteristics.
%       2. Initial Condition Response: Shows the response of the system to the
%          specified initial conditions with transient time characteristics.
function responseVisualization(system, Initial_state, ShowResponse, ShowInitialResponse)
    arguments
        system
        Initial_state
        ShowResponse = true
        ShowInitialResponse = true
    end

    % Check if the MATLAB version is newer than or equal to 2024b to use the new features
    v = ver('MATLAB');
    releaseYear = str2double(v.Release(3:6));
    releaseLetter = v.Release(7);
    new_feature_available = (releaseYear >= 2024 && releaseLetter >= 'b');

    % Step response of the closed-loop system
    if ShowResponse
        figure("Name", "Step Response");
        sp = stepplot(system); % Step response
        setoptions(sp, 'Grid', 'on'); % Show grid
        if new_feature_available
            sp.Responses.LineWidth = 2; % Set linewidth
            sp.Characteristics.PeakResponse.Visible = true; % Show peak response characteristic
            sp.Characteristics.SettlingTime.Visible = true; % Show settling time characteristic
        else
            % Get axes objects
            axesHandles = findobj(gcf, 'Type', 'axes');
            % Set lineWidth for each axes
            for k = 1:numel(axesHandles)
                lines = findobj(axesHandles(k), 'Type', 'line'); % Find all lines
                set(lines, 'LineWidth', 2); % Set linewidth
            end
            showCharacteristic(sp, 'PeakResponse');
            showCharacteristic(sp, 'SettlingTime');
        end
    end

    % Initial condition response
    if ShowInitialResponse
        figure("Name", "Initial Condition Response");
        ip = initialplot(system, Initial_state); % Initial condition response
        setoptions(ip, 'Grid', 'on'); % Show grid
        if new_feature_available
            ip.Responses.LineWidth = 2; % Set linewidth
            ip.Characteristics.TransientTime.Visible = true; % Show transient time characteristic
        else
            % Get axes objects
            axesHandles = findobj(gcf, 'Type', 'axes');
            % Set lineWidth for each axes
            for k = 1:numel(axesHandles)
                lines = findobj(axesHandles(k), 'Type', 'line'); % Find all lines
                set(lines, 'LineWidth', 2); % Set linewidth
            end
            showCharacteristic(ip, 'TransientTime');
        end
    end

end