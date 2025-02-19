%% Global Settings
% Task selection
runTask = struct;
runTask.task_1 = false;
runTask.task_2 = false;
runTask.task_3 = false;
runTask.task_4 = false;
runTask.task_5 = false;
runTask.task_6 = true;

% Response Visualization
ShowResponse = true;
ShowInitialResponse = true;

% Simulation
RunSim = true;
stateFeedback_model_path = "model/stateFeedback.slx";
observerStateFeedback_model_path = "model/observerStateFeedback.slx";
decoupleControl_model_path = "model/decoupleControl.slx";
servoControl_model_path = "model/servoControl.slx";
servoStateControl_model_path = "model/servoStateControl.slx";
scope_name = "Scope";
sim_time = 30;
OpenSimGUI = true;
CloseAfterSim = false;

% reference and load disturbance
% r = [0; 0]; % Reference input
% w = [0; 0]; % Load disturbance
r = [100; 150]; % Reference input
w = [-2; 5]; % Load disturbance
t_d = 10; % Load disturbance time
x_ref = [5; 250; 300]; % Reference state

% Transient response parameters
overshoot = 0.1; % 10% overshoot
settling_time = 30; % unit: s
delta_zeta = 0.05; % Damping ratio delta
delta_w_n = 0.05; % Natural frequency delta

%% Parameters Initialization
% Coustomized parameters based on student ID
student_id = "A0298466H";
last_four_digits = getLastFourDigits(student_id);
a = last_four_digits(1);
b = last_four_digits(2);
c = last_four_digits(3);
d = last_four_digits(4);
ab0 = a*100 + b*10 + 0;
ba0 = b*100 + a*10 + 0;
cd0 = c*100 + d*10 + 0;
dc = d*10 + c;

% System parameters
A = [-1.7, -0.25, 0; 
    23, -30, 20; 
    0, -200 - ab0, -220 - ba0];

B = [3 + a, 0; 
    -30 - dc, 0; 
    0, -420 - cd0];

C = [0, 1, 0; 
    0, 0, 1];

D = zeros(size(C, 1), size(B, 2));

x_0 = [1; 100; 200];