% setPointResponse Simulates and plots the response of a system to a setpoint input.
%
% setPointResponse Simulates and plots the response of a system to a setpoint input.
%
%   setPointResponse(system, setPoint, sim_time, IC) simulates the response of
%   the given system to a constant setpoint input over the specified
%   simulation time, starting from the provided initial conditions. It plots
%   the system's response and highlights the peak response.
%
%   Inputs:
%       system    - The dynamic system model (e.g., transfer function, state-space model).
%       setPoint  - The desired setpoint value for the system (default: ones(length(system.A), 1)).
%       sim_time  - The total simulation time (in seconds) (default: 1).
%       IC        - The initial conditions of the system (default: zeros(length(system.A), 1)).
%
%   Example:
%       sys = tf([1], [1, 2, 1]);                  % Define a transfer function system
%       initial_state = zeros(length(sys.A), 1);    % Initial state of the system
%       setPointResponse(sys, [1; 1], 10, initial_state); % Simulate and plot response
function setPointResponse(system, setPoint, sim_time, IC)
    arguments
        system
        setPoint = ones(length(system.A), 1)
        sim_time = 1
        IC = zeros(length(system.A), 1)
    end
    % Give setpoint and step disturbance
    t = 0:0.01:sim_time;
    u = setPoint * ones(size(t));
    figure("Name", "Set Point Response");
    lp = lsimplot(system, u, t, IC); % Response to setpoint
    lp.Characteristics.PeakResponse.Visible = true;
    % Get axes objects
    axesHandles = findobj(gcf, 'Type', 'axes');
    % Set lineWidth for each response line
    for k = 1:numel(axesHandles)
        lines = findobj(axesHandles(k), 'Type', 'line'); % Find all lines
        responseLines = lines(strcmp({lines.Tag}, 'SimulationResponseLine'));
        set(responseLines, 'LineWidth', 2);
    end
    setoptions(lp, 'Grid', 'on'); % Show grid
end
