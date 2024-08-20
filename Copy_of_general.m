clc;
clear;
close all;

% k is density , q is flow rate, v is speed

syms k;
% define flow rate formula here
fq = @(k) k * ( 1 - k);
% dq = diff(q);
dq = @(k) 1 - 2*k;

% def function here *********
% f is a cell{}
% <@t, k, @symbol_left, @value, @symbol_right, @value>
f = {};
f{1} = [0, 0.1, ">=", 0, "<=", 1];   %  0 <= x <= 1
f{2} = [0, 0.9, ">", 1, "<=", 2];   %  1 <  x <= 2
f{3} = [0, 0.2, ">", 2, "<=", 3];  %  2 <  x <= 3
f{4} = [0, 0.4, ">", 3, "<=", 4];
f{5} = [0, 0.7, ">", 4, "<=", 5];
f{6} = [0, 0.9, ">", 5, "inf", 0];
t0 = 0;
t1 = 10;
xlim_init = str2double(f{1}(3));
if f{end}(4) ~= "inf" 
    xlim_end = str2double(f{end}(5));
else
    xlim_end = str2double(f{end}(3)) + 1;
end

% stroe all lines [t, type, lamda, bias] , t is time, type is shock or rare
% fraction wave type
mLines = {};


for i = t0 : t1
    % f_minus = f{i};
end

% check number of subsegments
num = length(f);
for i = 1 : num-1
    f_minus = f{i};
    k_minus = str2double(f_minus(1));
    fq_minus = fq(k_minus);
    dq_minus = dq(k_minus);

    f_plus = f{i+1};
    k_plus = str2double(f_plus(1));
    fq_plus = fq(k_plus);
    dq_plus = dq(k_plus);
    % disp([q_minus, dq_minus, q_plus, dq_plus]);
    x0 = str2double(f_plus(3));
    
    if f_plus(4) ~= "inf"
        x1 = str2double(f_plus(5));
    else 
        x1 = x0+1;
    end

    if dq_minus < dq_plus
        disp("it is rarefraction wave.");



        % draw2DLines(dq_plus, dq_minus);
        % draw2Dfills(dq_plus, dq_minus);
        % draw3Dfills(dq_plus, dq_minus);
        % draw2DFillsForRW(dq_plus,dq_minus, k_plus, k_minus, x0, t0, x1,t1, xlim_init, xlim_end);
    elseif dq_minus > dq_plus
        disp("it is shock wave.");
        lamda = RHsolver(fq_plus, fq_minus, k_plus, k_minus);
        % get bias
        bias = x0 - lamda*t0;
        % draw2DFillsForSW(fq_plus,fq_minus, k_plus, k_minus, x0, t0, x1,t1, xlim_init, xlim_end);
    else
        disp("same results, no wave appeared.")
    end
    % pause
end

function draw2DFillsForSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0, x1, t1, xlim_init, xlim_end)
    % lamda = (fq_plus - fq_minus) / (k_plus - k_minus)
    lamda = RHsolver(fq_plus, fq_minus, k_plus, k_minus)
    % get bias
    bias = x0 - lamda*t0;
    % 
    t = t0 :0.1:t1;
    x = lamda * t + bias;
    plot(x,t);
    hold on;
    xlim([xlim_init, xlim_end]);
    ylim([0,10]);
    % syms x t;
    % t1 = @(x) lamda * x + 
end

function draw2DFillsForRW(dq_plus, dq_minus, k_plus, k_minus, x0, t0, x1, t1, xlim_init, xlim_end)
    gap = 32;
    t = t0 :0.1:t1;
    bias = x0 - dq_plus*t0;

    xp = dq_plus * t + bias;
    xm = dq_minus * t + bias;
    plot(xp, t);
    hold on;
    plot(xm, t);
    hold on;
    
end

% Rankine - Hugoniot
% fQk_plus: Q(k+)
function v = RHsolver(fQk_plus, fQk_minus, k_plus, k_minus)
    v = (fQk_plus - fQk_minus) / (k_plus - k_minus);
end
