% secondOrderPoles calculates the dominant poles of a second-order system
% based on the desired overshoot, settling time, and adjustments to the
% damping ratio and natural frequency.
%
% Syntax:
%   [p1, p2] = secondOrderPoles(overshoot, settling_time, delta_zeta, delta_w_n)
%
% Inputs:
%   overshoot      - Desired overshoot (as a decimal, e.g., 0.2 for 20%)
%   settling_time  - Desired settling time (in seconds)
%   delta_zeta     - Adjustment to the damping ratio (zeta)
%   delta_w_n      - Adjustment to the natural frequency (w_n)
%
% Outputs:
%   p1 - Dominant pole 1 (complex number)
%   p2 - Dominant pole 2 (complex number)
%
% Example:
%   [p1, p2] = secondOrderPoles(0.2, 2, 0.01, 0.5)
%   This example calculates the dominant poles for a system with 20% overshoot,
%   2 seconds settling time, and slight adjustments to the damping ratio and
%   natural frequency.
function [p1, p2] = secondOrderPoles(overshoot, settling_time, delta_zeta, delta_w_n)
    % Desired poles calculation
    zeta = -log(overshoot) / sqrt(pi^2 + log(overshoot)^2); % Damping ratio
    w_n = 4 / (zeta * settling_time); % Natural frequency
    disp("Damping Ratio (zeta): " + zeta);
    disp("Natural Frequency (w_n): " + w_n);
    zeta = round(zeta + delta_zeta, 2); % Slightly increase zeta and round to 2 decimal places
    w_n = round(w_n + delta_w_n, 2); % Slightly increase w_n and round to 1 decimal place
    disp("Damping Ratio (zeta): " + zeta);
    disp("Natural Frequency (w_n): " + w_n);
    p1 = -zeta * w_n + 1i * w_n * sqrt(1 - zeta^2); % Dominant pole 1
    p2 = -zeta * w_n - 1i * w_n * sqrt(1 - zeta^2); % Dominant pole 2
end
