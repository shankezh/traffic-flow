classdef WAVES <handle

    properties
        cell_waves;
        mpx; % meet_point_x
        mpt; % meet_point_t
        mp_count;
    end
    methods
        function obj= init(obj)
            obj.cell_waves = {};
            obj.mpx = [];
            obj.mpt = [];
            obj.mp_count = 0;
        end

        function add_meet_point(obj, x, t)
            obj.mpt = [obj.mpt, t];
            obj.mpx = [obj.mpx, x];
            obj.mp_count = obj.mp_count + 1;
        end

        function clean_meet_point(obj)
            obj.mpx = [];
            obj.mpt = [];
            obj.mp_count = 0;
        end

        function obj = addWave(obj, mWave)
            obj.cell_waves = horzcat(obj.cell_waves, mWave);
        end

        function cal_meet_points(obj)
            % num of waves
            num = length(obj.cell_waves);
            for i = 1 : num-1
                cur_slope = 0;
                cur_bias = 0;
                next_slope = 0;
                next_bias = 0;
                if obj.cell_waves(i).type == "shockwave"
                    cur_slope = obj.cell_waves(i).slopes;
                    cur_bias = obj.cell_waves(i).biasses;
                else
                    cur_slope = obj.cell_waves(i).slopes(end);
                    cur_bias = obj.cell_waves(i).biasses(end);
                end
                
                if obj.cell_waves(i+1).type == "shockwave"
                    next_slope = obj.cell_waves(i+1).slopes;
                    next_bias = obj.cell_waves(i+1).biasses;
                else
                    next_slope = obj.cell_waves(i+1).slopes(1);
                    next_bias = obj.cell_waves(i+1).biasses(1);
                end
                meet_point_time = obj.t_solve(cur_slope, cur_bias, next_slope, next_bias);
                if meet_point_time > 0
                    meet_point_x = cur_slope * meet_point_time + cur_bias;
                    obj.add_meet_point(meet_point_x, meet_point_time);
                end
            end
        end

        function t = t_solve(obj, cur_slope, cur_bias, next_slope, next_bias)
            t = (next_bias - cur_bias) / (cur_slope - next_slope);
        end

        
        % judge meet point belong to restrain area
        function [b, mps_uni, mps_aim] = is_exist_meet_points(obj, t_init, t_end, xlim_init, xlim_end)
            b = false;
            mp_list = [];
            mps_uni = [];
            mps_aim = [];
            % Do not have meet point
            if obj.mp_count == 0
                return;          
            end
 
            for i = 1 : obj.mp_count
                if obj.mpt(i) > t_init && obj.mpt(i) <= t_end && obj.mpx(i)> xlim_init && obj.mpx(i) <= xlim_end
                    b = true;
                    mp_list = [mp_list; obj.mpx(i), obj.mpt(i)];
                end
            end

            if b == true
                mps_uni = unique(mp_list, 'rows');
                [min_t, idx] = min(mps_uni(:,2));
                mps_aim = [mps_uni(idx,1),mps_uni(idx,2)];
            end
            
        end
        



        function [list_x, list_d] = build_new_ld(obj, mp_t, xlim_init, xlim_end)
            num = length(obj.cell_waves);
            list_x = [xlim_init];
            list_d = [];
            last_x = xlim_init;
            epsilon = 1e-10;
            for i = 1:num
                if obj.cell_waves(i).type == "shockwave"
                    slope = obj.cell_waves(i).slopes;
                    bias = obj.cell_waves(i).biasses;
                    cur_x = slope * mp_t + bias;
                    if ~(abs(cur_x - last_x) < epsilon) && cur_x < last_x 
                        disp("ShockWave: should not over than range (x_init, x_end).");
                        disp("last_x:"+ last_x+ ",i:" +i+',mp_t:'+mp_t+",cur_x:"+cur_x);
                        continue;
                        % pause;
                    end
                    if ~(abs(cur_x - last_x) < epsilon)  % not meet point
                        list_x = [list_x, cur_x];
                        list_d = [list_d, obj.cell_waves(i).k_minus];
                        last_x = cur_x;
                    end
                    % the last point, get k_plus
                    if num == i
                        list_d = [list_d, obj.cell_waves(i).k_plus];
                    end

                else
                    % rare fraction wave
                    for j = 1:obj.cell_waves(i).lines_count
                        slope = obj.cell_waves(i).slopes(j);
                        bias = obj.cell_waves(i).biasses(j);
                        cur_x = slope * mp_t + bias;
                        if ~(abs(cur_x - last_x) < epsilon) && cur_x < last_x  
                            disp("RareFractionWave: should not over than range (x_init, x_end).");
                            disp(["slope"+slope+",bias"+bias,"mLInes "+obj.cell_waves(i).lines_count]);
                            disp("find here"+i+'j'+j+'last_x'+last_x+"cur_x"+cur_x);
                            continue;
                            % pause;
                        end
                        if ~(abs(cur_x - last_x) < epsilon) % not meet point
                            list_x = [list_x, cur_x];
                            list_d = [list_d, obj.cell_waves(i).k_minus(j)];
                            last_x = cur_x;
                        end
                        if num == i && j == obj.cell_waves(i).lines_count
                            list_d = [list_d, obj.cell_waves(i).k_plus(j)];
                        end

                        
                    end
                end
            end
            list_x = [list_x, xlim_end];
        end
    end
end