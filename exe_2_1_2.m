clear;
close all;
clc;
% k is density , q is flow rate, v is speed

syms k;
% define flow rate formula here
q =@(k) k * ( 1 - k);
% dq = diff(q);
dq = @(k) 1 - 2*k;

% define k+ and k-
k_minus = 0.9;
k_plus = 0.2;

% get q+ and q-
q_minus = q(k_minus);
q_plus  = q(k_plus);

% get dq+ and dq-
dq_minus = dq(k_minus);
dq_plus = dq(k_plus);

% get lamda by Rankine-Hugonoit
lamda = (q_plus - q_minus) / (k_plus - k_minus);

% judge is shock wave or rarefraction wave
if dq_minus < dq_plus
    disp("it is rarefraction wave.");
    draw2DLines(dq_plus, dq_minus, k_plus, k_minus);
    % draw2Dfills(dq_plus, dq_minus);
    % draw3Dfills(dq_plus, dq_minus);
elseif dq_minus > dq_plus
    disp("it is shock wave.");
else
    disp("same results, no wave appeared.")
end



function draw3Dfills(dq_plus, dq_minus)
    t = 0:0.0005:1;
    %define gap for ki
    gap = 10;
    delta_k = (dq_plus - dq_minus) / gap;
    x_i = [];
    for i = 0 : gap
        xtemp = dq_minus + delta_k * i;
        x_i = [x_i, xtemp];
    end
    
    figure(2);
    [x, t] = meshgrid(-1:0.0005:1, 0:0.0005:1);
    z = zeros(size(x));
    
    boundary = {};
    for i = 1 : length(x_i)
        boundary{i} = x_i(i) * t;
    end
    
    slice_k = 0.8 / 33;
    z(x<boundary{1}) = 0.8;
    for i = 1 : gap
        gradient_k = 0.8 - slice_k * i;
        z(x>boundary{i}&x<boundary{i+1}) = gradient_k;
    end
    surf(x, t, z, 'EdgeColor', 'none'); % 使用'EdgeColor'为'none'以去除网格线
    drawnow();
    % colormap([0 0 1; ...
    %     1 1 0]);
    xlabel('x');
    ylabel('t');
    zlabel('density');
end



function draw2Dfills(dq_plus, dq_minus)
   
    
    %define gap for ki
    gap = 10;
    delta_k = (dq_plus - dq_minus) / gap;
    x_i = [];
    for i = 0 : gap
        xtemp = dq_minus + delta_k * i;
        x_i = [x_i, xtemp];
    end
    inx = length(x_i);
    fills_t = {};
    fills_x = {};
    for i = 1 : inx
    
        if i == 1
            fills_x{i} = [0 -1 -1 x_i(i)];
            fills_t{i} = [0  0  1  1];
        else
            fills_x{i} = [0 x_i(i-1) x_i(i) 0];
            fills_t{i} = [0 1 1 0 ];
        end
    
        fill(fills_x{i}, fills_t{i}, inx - i);
        hold on;
    end
    fills_x{inx+1} = [0 x_i(inx) 1 0];
    fills_t{inx+1} = [0 1 0 0];
    fill(fills_x{inx+1}, fills_t{inx+1}, 1,'EdgeColor', 'none','LineStyle','none');
    

end

function draw2DLines(dq_plus, dq_minus, k_plus, k_minus)
    % draw 2d plot for rarefraction wave
    t = 0:0.1:1;
    
    %define gap for ki
    gap = 32;
    
    delta_dq = (dq_plus - dq_minus) / gap
    delta_dk = (k_plus - k_minus) / gap
    x_i = [];
    x_k = [];
    for i = 0 : gap
        xtemp = dq_minus + delta_dq * i;
        ktemp = k_minus + delta_dk * i;
        x_i = [x_i, xtemp];
        x_k = [x_k, ktemp];
    end
    x_k
    
    for i = 1 : length(x_i)
        x = t * x_i(i);
        plot(x, t);
        hold on;
    end
    
    xlim([-1,1]);
    ylim([0,1]);
    xlabel('x');
    ylabel('t');
end
