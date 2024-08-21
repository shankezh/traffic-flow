% cell_lenght: road segment lenght, unit km
% n_last: number of vehicles in last moment
% a2b: vehicles flow in from last segment road 
% b2c: vehicles flow out from last segment road 
% b_in: vehicles flow in from ramp
% b_out: vehicle flow out from ramp

% n: current number of vehicles
% k: current density
% v: speed of balance state
function [n, k, v] = MFLEFLO(cell_lenght, n_last, a2b, b2c, b_in, b_out)
    n = n_last + a2b - b2c + b_in - b_out;
    k = n / cell_lenght;
    v = min(88.5, (172-3.72*k+0.0346*k^2-0.00119*k^3));
end