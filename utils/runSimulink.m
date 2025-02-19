% RUNSIMULINK Run a Simulink model with specified parameters.
%
%   runSimulink(model_name, scope_name, sim_time, OpenSimGUI, CloseAfterSim)
%   runs the specified Simulink model for a given simulation time and
%   optionally opens the Simulink GUI and closes the model after simulation.
%
%   Arguments:
%   model_name (string) - Name of the Simulink model to run.
%   scope_name (string) - Name of the scope within the model to open.
%   sim_time (double) - Simulation time in seconds.
%   OpenSimGUI (logical) - Optional. If true, opens the Simulink GUI. 
%                          Default is true.
%   CloseAfterSim (logical) - Optional. If true, closes the model after 
%                             simulation. Default is false.
%
%   Example:
%   runSimulink('my_model', 'my_scope', 10, true, false)
%   This example runs the 'my_model' Simulink model for 10 seconds, opens
%   the Simulink GUI, and does not close the model after simulation.
function runSimulink(model_path, scope_name, sim_time, OpenSimGUI, CloseAfterSim)
    % Run the simulink model
    arguments
        model_path string
        scope_name string
        sim_time double
        OpenSimGUI = true
        CloseAfterSim = false
    end

    % Open the model if OpenSimGUI is true
    if OpenSimGUI
        open_system(model_path);
    else
        load_system(model_path);
    end
    
    % Open the scope
    [~, model_name, ~] = fileparts(model_path);
    scope = strcat(model_name, '/', scope_name);
    open_system(scope);
    
    % Start simulation
    sim(model_path, "StopTime", num2str(sim_time));
    
    % Close the model after simulation if CloseAfterSim is true
    if CloseAfterSim
        close_system(model_path, 0);
    end
end
