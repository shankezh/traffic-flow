classdef LDFormula <handle 
    properties
        densities=[];
        %   a <(more than) x  (less than or equal to)<= b
        less_than_and_et=[];
        more_than = [];
        count = 0;
    end
    methods
        function insert(obj, density, a, b)
            val_a = 0;
            val_b = 0;
            if (isstring(a) || ischar(a)) && (isstring(b) || ischar(b))
                error("err, can not allow both are inf.");
            elseif isstring(a) || ischar(a)
                val_a = b - 1;
                val_b = b;
            elseif isstring(b) || ischar(b)
                val_b = a + 1;
                val_a = a;
            else
                val_a = a;
                val_b = b;
            end
            obj.densities = [obj.densities, density];
            obj.more_than = [obj.more_than, val_a];
            obj.less_than_and_et = [obj.less_than_and_et, val_b];
            obj.count = obj.count + 1;
        end
    end

end
    