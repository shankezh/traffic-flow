classdef WAVE <handle

    properties
        region_no;
        time;
        type;   % 'shockwave' | 'rarefractionwave'
        slopes;
        biasses;
        k_plus;
        k_minus;
        lines_count;
    end
    methods
        function obj = init(obj, region_no, time)
            obj.region_no = region_no;
            obj.time = time;
            obj.lines_count = 0;
            obj.type = "rarefractionwave";
        end

        function obj = addShockWave(obj, slope, bias,  k_plus, k_minus)
            obj.slopes = slope;
            obj.biasses = bias;
            obj.k_minus = k_minus;
            obj.k_plus = k_plus;
            obj.lines_count = 1;
            obj.type = "shockwave";
        end
        
        function obj = addRarefractionWaveLine(obj, slope, bias,  k_plus, k_minus)
            obj.lines_count = obj.lines_count + 1;
            obj.slopes = [obj.slopes, slope];
            obj.biasses = [obj.biasses, bias];
            obj.k_plus = [obj.k_plus, k_plus];
            obj.k_minus = [obj.k_minus, k_minus];
        end
    end
end