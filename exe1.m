clc;
clear;

% Parameters
v_max = 30; % Maximum velocity (m/s)
rho_max = 0.1; % Maximum density (vehicles/m)
L = 1000; % Length of the road (m)
dx = 1; % Space step (m)
dt = 0.1; % Time step (s)
T = 100; % Total time (s)

% Initial conditions
x = 0:dx:L; % Spatial grid
rho = zeros(size(x)); % Initial density
rho(200:400) = 0.05; % Example initial traffic density

% Greenshields model for fundamental diagram
Q = @(rho) v_max * rho .* (1 - rho / rho_max);

% Time-stepping loop
for t = 0:dt:T
    % Calculate flow
    q = Q(rho);
    
    % Update density using finite difference method
    rho(2:end-1) = rho(2:end-1) - dt/dx * (q(3:end) - q(1:end-2));
    
    % Boundary conditions (e.g., periodic boundary)
    rho(1) = rho(end-1);
    rho(end) = rho(2);
    
    % Plot density
    plot(x, rho);
    xlabel('Position (m)');
    ylabel('Density (vehicles/m)');
    title(['Time = ' num2str(t) ' s']);
    hold on;
    drawnow;
end

