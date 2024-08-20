clc;
clear;
close all;

% k is density , q is flow rate, v is speed

syms k;
% define flow rate formula here
fq = @(k) k * ( 1 - k);
% dq = diff(q);
dq = @(k) 1 - 2*k;

rf_gap = 32;
rf_gap_density = 0;

t0 = 0;
t_end = 10;

% def function here *********
% f is a cell{}
% <k, @symbol_left, @value, @symbol_right, @value>
sets_f = {};
ldfor = LDFormula();
ldfor.insert(0.1, "inf", 1);
ldfor.insert(0.5, 1, 2);
ldfor.insert(0.3, 2, 3);
ldfor.insert(0.5, 3, 4);
ldfor.insert(0.7, 4, 5);
ldfor.insert(0.9, 5, "inf");
sets_f = horzcat(sets_f, ldfor);



xlim_init = sets_f(1).more_than(1);
xlim_end = sets_f(1).less_than_and_et(end);

% stroe all lines [t, type, region no., lamda, bias] , t is time, type is shock or rare
% warefaction wave type
sets_fw = {};
mWaves = WAVES();
mWaves.init();
sets_fw = horzcat(sets_fw, mWaves);

% check number of subsegments
for i = 1 : sets_f(1).count-1
    k_minus = sets_f(1).densities(i);
    fq_minus = fq(k_minus);
    dq_minus = dq(k_minus);

    k_plus = sets_f(1).densities(i+1);
    fq_plus = fq(k_plus);
    dq_plus = dq(k_plus);
    % disp([q_minus, dq_minus, q_plus, dq_plus]);
    x0 = sets_f(1).more_than(i+1);
    x1 = sets_f(1).less_than_and_et(i+1);

    if dq_minus < dq_plus
        disp("it is rarefraction wave.");
        if rf_gap_density == 0
            [rf_gap_density] = abs(getRW(rf_gap,dq_plus, dq_minus, k_plus, k_minus,x0, t0, i, mWaves));
            rf_gap_density = rf_gap_density * 1.1; % avoid percision problem
        else
            getRW(rf_gap,dq_plus, dq_minus, k_plus, k_minus,x0, t0, i, mWaves);
        end

        % draw2DLines(dq_plus, dq_minus);
        % draw2Dfills(dq_plus, dq_minus);
        % draw3Dfills(dq_plus, dq_minus);
        
        draw2DFillsForRW(dq_plus,dq_minus, k_plus, k_minus, x0, t0, x1,t_end, xlim_init, xlim_end,i, mWaves);
    elseif dq_minus > dq_plus
        disp("it is shock wave.");
        getSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0, i, mWaves);
        draw2DFillsForSW(fq_plus,fq_minus, k_plus, k_minus, x0, t0, x1,t_end, xlim_init, xlim_end,i,mWaves);
    else
        disp("same results, no wave appeared.")
    end
    % mLines = horzcat(mLines, tempLines);
    % pause
end

% calculating meet points for all waves
mWaves.cal_meet_points();

% pause;
for i = t0:t_end-1
    t_init = i;
    t_end = i + 1;
    while(true)
        disp(["t_init:", t_init, "--- t_end: ", t_end]);
        % [is_exist, mps_uni, mps_aim] = mWaves.is_exist_meet_points(t_init,t_end);
        [is_exist, mps_uni, mps_aim] = sets_fw(end).is_exist_meet_points(t_init, t_end, xlim_init, xlim_end);
 
        if is_exist == false
            disp("Do not have meet point in current time range.")
            break;
        else
            disp("Here have meet point .......")
        end

        meet_point_t = mps_aim(2);
        % t_init;
        [cell_fills, cell_colors, cell_densities] = getFillsAreas(sets_fw(end), t_init, meet_point_t, xlim_init, xlim_end);
        t_init = meet_point_t;
        t_end = i + 1;
        % toFills2DAreas(cell_fills, cell_colors);
        % toFills3DAreas(cell_fills, cell_colors, cell_densities);
        toFills2Dand3DAreas(cell_fills, cell_colors, cell_densities);
        
        % get area and condtions
        [list_x, list_d] = sets_fw(end).build_new_ld(t_init, xlim_init, xlim_end);
        % build new speed-density function here
        ld_for = generate_ld_formula(list_x, list_d);
        sets_f = horzcat(sets_f, ld_for);
        new_waves = generate_waves(sets_f, rf_gap_density, rf_gap, t_init);
        sets_fw = horzcat(sets_fw, new_waves);
        % calculating meet points for all waves
        sets_fw(end).cal_meet_points();


        % pause;
    end
    [cell_fills, cell_colors, cell_densities] = getFillsAreas(sets_fw(end), t_init, t_end, xlim_init, xlim_end);
    % toFills2DAreas(cell_fills, cell_colors);
    % toFills3DAreas(cell_fills, cell_colors, cell_densities);
    toFills2Dand3DAreas(cell_fills, cell_colors, cell_densities);
    % if i == 1
    %     disp("here")
    %     return
    % end
    % pause;
end

% build new waves by LDformula
function [mWaves, rf_gap_density] = generate_waves(sets_f, rf_gap_density, rf_gap, t0)
    fq = @(k) k * ( 1 - k);
    dq = @(k) 1 - 2*k;
    mWaves = WAVES();
    mWaves.init();
    for i = 1 : sets_f(end).count-1
        k_minus = sets_f(end).densities(i);
        fq_minus = fq(k_minus);
        dq_minus = dq(k_minus);
        k_plus = sets_f(end).densities(i+1);
        fq_plus = fq(k_plus);
        dq_plus = dq(k_plus);
        x0 = sets_f(end).less_than_and_et(i);
        if dq_minus < dq_plus
            if rf_gap_density == 0
                rf_gap_density = abs(getRW(rf_gap,dq_plus, dq_minus, k_plus, k_minus,x0, t0, i, mWaves));
                rf_gap_density = rf_gap_density * 1.1; % avoid percision problem
                disp("it is rarefraction wave.");
            else
                if abs(k_minus - k_plus) <= rf_gap_density
                    disp("it is shock wave, becuase the density gap is less than restrain value.");
                    getSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0, i, mWaves);
                else
                    getRW(rf_gap,dq_plus, dq_minus, k_plus, k_minus,x0, t0, i, mWaves);
                    disp("it is rarefraction wave.");
                end
                
            end
        elseif dq_minus > dq_plus
            disp("it is shock wave.");
            getSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0, i, mWaves);
        else
            disp([k_plus, k_minus, dq_minus, i])
            disp("same results, no wave appeared.")
        end
    end
end

% build new location and density formula
function ldfor = generate_ld_formula(list_x, list_d)
    ldfor = LDFormula();
    for i = 1: length(list_x)-1
        ldfor.insert(list_d(i), list_x(i), list_x(i+1));
    end
end

function toFills3DAreas(fills, colors, densities)
    figure(3);
    [m,n] = size(fills);
    for i = 2 : m - 1
        fills(i,1) = min(max(fills(i, 1), fills(1,1)), fills(end,1));
        fills(i,3) = min(max(fills(i, 3), fills(1,3)), fills(end,3));
    end
    for i = 1 : m-1
        left_top_x = fills(i,1);
        left_top_t = fills(i,2);
        left_bot_x = fills(i,3);
        left_bot_t = fills(i,4);
        right_top_x = fills(i+1,1);
        right_top_t = fills(i+1,2);
        right_bot_x = fills(i+1,3);
        right_bot_t = fills(i+1,4);
        x = [left_top_x, left_bot_x, right_bot_x, right_top_x];
        y = [left_top_t, left_bot_t, right_bot_t, right_top_t];
        color = colors(i,:);
        z = [densities(i), densities(i), densities(i), densities(i)];
        fill3(x,y,z,color,"EdgeColor","none");
        drawnow();
        pause(10/1000);
        hold on;
    end

end

function toFills2Dand3DAreas(fills, colors, densities)
    figure(2);
    [m,n] = size(fills);
    for i = 2 : m - 1
        fills(i,1) = min(max(fills(i, 1), fills(1,1)), fills(end,1));
        fills(i,3) = min(max(fills(i, 3), fills(1,3)), fills(end,3));
    end
    % sx_l = min(fills(:,1));
    % sx_r = max(fills(:,1));
    % sy_top = max(fills(:,2));
    % sy_bot = min(fills(:,4));
    % [sx, sy] = meshgrid(linspace(sx_l,sx_r,200), linspace(sy_bot,sy_top,200));
    % sz = zeros(size(sx));

    % colormap(colors);
    % disp([sx_l,sx_r, sy_top,sy_bot]);
    for i = 1 : m-1
        left_top_x = fills(i,1);
        left_top_t = fills(i,2);
        left_bot_x = fills(i,3);
        left_bot_t = fills(i,4);
        right_top_x = fills(i+1,1);
        right_top_t = fills(i+1,2);
        right_bot_x = fills(i+1,3);
        right_bot_t = fills(i+1,4);
        x = [left_top_x, left_bot_x, right_bot_x, right_top_x];
        y = [left_top_t, left_bot_t, right_bot_t, right_top_t];
        color = colors(i,:);
        z = [densities(i), densities(i), densities(i), densities(i)];
        subplot(1,2,1);
        fill(x,y,color,"EdgeColor","none");
        title("space-time diagram");
        xlabel("x(space)");
        ylabel("t(time->unit: sec.)");
        hold on;
        
        % in = inpolygon(sx, sy,x,y);
        % sz(in)=densities(i);
        subplot(1,2,2);
        fill3(x,y,z,color,"EdgeColor","none");
        hold on;
        title("space-time diagram with density");
        xlabel("x(space)");
        grid on;
        ylabel("t(time->unit: sec.)");
        zlabel("density");
        zlim([0,1]);
        drawnow();
        pause(1/1000);
        
    end
    % subplot(1,2,2);
    
    % surf(sx,sy,sz,'EdgeColor', 'none');
    % shading interp;
    % title("space-time diagram with density");
    % xlabel("x(space)");
    % ylabel("t(time->unit: sec.)");
    % zlabel("density");
    
    colorbar;
    hold on;
end

function toFills2DAreas(fills, colors)
    figure(2);
    [m,n] = size(fills);
    % ensure x is located x_init to x_end
    for i = 2 : m - 1
        fills(i,1) = min(max(fills(i, 1), fills(1,1)), fills(end,1));
        fills(i,3) = min(max(fills(i, 3), fills(1,3)), fills(end,3));
    end
    for i = 1 : m-1
        left_top_x = fills(i,1);
        left_top_t = fills(i,2);
        left_bot_x = fills(i,3);
        left_bot_t = fills(i,4);
        right_top_x = fills(i+1,1);
        right_top_t = fills(i+1,2);
        right_bot_x = fills(i+1,3);
        right_bot_t = fills(i+1,4);
        x = [left_top_x, left_bot_x, right_bot_x, right_top_x];
        y = [left_top_t, left_bot_t, right_bot_t, right_top_t];
        color = colors(i,:);
        fill(x,y,color,"EdgeColor","none");
        drawnow();
        pause(10/1000);
        hold on;
    end
end

function [fills, colors, densities] = getFillsAreas(mWaves, t_init, t_end, x_init, x_end)
    num = length(mWaves.cell_waves);
    % first point [left_top_x, left_top_t, left_bottom_x, left_bottom_t]
    fills = [x_init, t_end, x_init, t_init];
    colors = [];
    densities  = [];
    for i = 1: num
        if mWaves.cell_waves(i).type == "shockwave"
            slope = mWaves.cell_waves(i).slopes;
            bias = mWaves.cell_waves(i).biasses;
            rt_x = slope * t_end + bias;
            rb_x = slope * t_init + bias;
            if i == 1
                colors = [colors; getColorByDensity(mWaves.cell_waves(i).k_minus)];
                densities = [densities, mWaves.cell_waves(i).k_minus];
            end
            fills = [fills; [rt_x, t_end, rb_x, t_init]];
            colors = [colors; getColorByDensity(mWaves.cell_waves(i).k_plus)];
            densities = [densities, mWaves.cell_waves(i).k_plus];
            
        else
            % rarefraction wave
            for j = 1 : mWaves.cell_waves(i).lines_count
                slope = mWaves.cell_waves(i).slopes(j);
                bias = mWaves.cell_waves(i).biasses(j);
                rt_x = slope * t_end + bias;
                rb_x = slope * t_init + bias;
                if i == 1 && j == 1
                    colors = [colors; getColorByDensity(mWaves.cell_waves(i).k_minus(j))];
                    densities = [densities, mWaves.cell_waves(i).k_minus(j)];         
                end
                % cell_fills{count} = {[rt_x, t_end], [rb_x, t_init]};
                fills = [fills; [rt_x, t_end, rb_x, t_init]];
                colors = [colors; getColorByDensity(mWaves.cell_waves(i).k_plus(j))];
                densities = [densities, mWaves.cell_waves(i).k_plus(j)];
            end
        end
    end
    % the last point [right_top_x, right_top_t, right_bottom_x, right_bottom_t]
    fills = [fills; [x_end, t_end, x_end, t_init]];
end


% get shock wave
function getSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0,no, mWaves)
    % [fq_plus, fq_minus]
    epsilon = 1e-10;
    if abs(fq_plus - fq_minus) < epsilon 
        slope = 0;
    else
        slope = RHsolver(fq_plus, fq_minus, k_plus, k_minus);
    end
    
    bias = x0 - slope*t0;
    mSW = WAVE();
    mSW.init(no, t0);
    mSW.addShockWave(slope, bias, k_plus, k_minus);
    mWaves.addWave(mSW);
end
% get rare fraction wave
% the 'gap' means how many lines insert both of dq_minus and dq_plus
function [gap_density_v, slopes, densities] = getRW(gap,dq_plus, dq_minus, k_plus, k_minus,x0, t0, no, mWaves)
    mRF = WAVE();
    mRF.init(no, t0);
    if gap == 0
        error("The gap value should not zero !");
    end
    slopes = zeros(1,gap+2);
    densities = zeros(1, gap+3);
    % the first line
    slopes(1) = dq_minus;
    % the last line
    slopes(end) = dq_plus;
    densities(1) = k_minus;
    densities(end) = k_plus;
    bias = x0 - dq_plus*t0;
    gap_slope_v = (dq_plus - dq_minus) / (gap + 1);
    gap_density_v = (k_plus - k_minus) / (gap + 2);

    for i = 1:gap
        slope_i = dq_minus + gap_slope_v * i;
        slopes(i+1) = slope_i;
        densities(i+1) = k_minus + gap_density_v * i;
        densities(i+2) = k_minus + gap_density_v * (i+1);
    end
    for i = 1 : length(slopes)
        mRF.addRarefractionWaveLine(slopes(i), bias, densities(i+1), densities(i));
    end

    mWaves.addWave(mRF);
end



function draw2DFillsForSW(fq_plus, fq_minus, k_plus, k_minus, x0, t0, x1, t1, xlim_init, xlim_end,no, mWaves)
    % lamda = (fq_plus - fq_minus) / (k_plus - k_minus)
    lamda = RHsolver(fq_plus, fq_minus, k_plus, k_minus);
    % get bias
    bias = x0 - lamda*t0;
    
    t = t0 :0.1:t1;
    x = lamda * t + bias;
    plot(x,t);
    hold on;
    xlim([xlim_init, xlim_end]);
    ylim([0,10]);
    % syms x t;
    % t1 = @(x) lamda * x + 
end

function draw2DFillsForRW(dq_plus, dq_minus, k_plus, k_minus, x0, t0, x1, t1, xlim_init, xlim_end, no, mWaves)
    gap = 32;
    t = t0 :0.1:t1;
    bias = x0 - dq_plus*t0;
    dq_delta = (dq_plus - dq_minus) / gap;
    dk_delta = (k_plus - k_minus) / gap;
    xi = [];
    for i = 0:gap
        temp_dq = dq_minus + dq_delta * i; 
        temp_dk_p = k_minus + dk_delta * i;
        temp_dk_m = k_minus + dk_delta * (i+1);
        xi = [xi, temp_dq];
    end
    % xp = dq_plus * t + bias;
    % xm = dq_minus * t + bias;
    for i = 1:length(xi)
        x = xi(i)*t + bias;
        plot(x, t);
        hold on;
    end
    % plot(xp, t);
    % hold on;
    % plot(xm, t);
    % hold on;
    
end

% Rankine - Hugoniot
% fQk_plus: Q(k+)
function v = RHsolver(fQk_plus, fQk_minus, k_plus, k_minus)
    v = (fQk_plus - fQk_minus) / (k_plus - k_minus);
end
