classdef FD_mixed <handle
    properties
        % length of vehicle body, unit : meter 
        l = 5;
        % minimum safe distance, unit: meter
        s0 = 2;

        % free speed
        vf = 33.3;
        % deisred headway
        tc_cacc;
        tc_acc;
        tc_idm;

        % time lag
        t_cacc;
        t_acc;
        t_idm;
    end
    

    methods
        function settingBasic(obj,l, s0, vf)
            obj.l = l;
            obj.s0 = s0;
            obj.vf = vf;
        end

        function settingDesiredHeadway(obj, tc_cacc, tc_acc, tc_idm)
            obj.tc_cacc = tc_cacc;
            obj.tc_acc = tc_acc;
            obj.tc_idm = tc_idm;
        end

        function settingTimeLag(obj, t_cacc, t_acc, t_idm)
            obj.t_cacc = t_cacc;
            obj.t_acc  = t_acc;
            obj.t_idm  = t_idm;
        end


        % Platoon Intensity: CAV follows HDV
        function possibilty = mPI_C2H(obj, pc, O)
            ph = 1-pc;
            if O >= 0
                possibilty = ph * (1 - O);
            else
                possibilty = ph + O * (ph - min(1,ph/pc));
            end
        end

        % Platoon Intensity: HDV follows CAV
        function possibilty = mPI_H2C(obj, pc, O)
            ph = 1-pc;
            if O >= 0
                possibilty = pc * (1 - O);
            else
                possibilty = pc + O * (pc - min(1, pc/ph));
            end
        end

        % Platoon Intensity: CAV follows CAV
        function possibility = mPI_C2C(obj, pc, O)
            possibility = 1 - obj.mPI_C2H(pc, O);
        end


        % Platoon Intensity: HDV follows HDV
        function possibilty = mPI_H2H(obj, pc, O)
            possibilty = 1 - obj.mPI_H2C(pc, O);
        end

        function distance = S_CACC(obj, v)
            distance = v * (obj.tc_cacc + obj.t_cacc) + obj.l + obj.s0;
        end

        function distance = S_ACC(obj, v)
            distance = v * (obj.tc_acc + obj.t_acc) + obj.l + obj.s0;
        end

        function distance = S_IDM(obj, v)
            if v > 60
                distance = obj.s0 + v*(obj.tc_idm + obj.t_idm) + obj.l;
            else
                distance = (obj.s0 + v*(obj.tc_idm + obj.t_idm)) / sqrt(1 - (v/obj.vf)^4) + obj.l;
            end

        end

        function fq = flow_rate(obj,v, pc, O)
            % fq = (1000 * v * 3.6) / (pc*pcc*s_cacc + pc*pch*s_acc + ph*s_idm);
            fq = obj.density(v, pc, O) * 3.6*1000*v;
        end

        function p = density(obj,v, pc, O)
            p = 1000  / obj.spacing(v, pc, O);
        end

        function s = spacing(obj, v, pc, O)
            ph = 1 - pc;
            pcc = obj.mPI_C2C(pc, O);
            pch = obj.mPI_C2H(pc, O);
            s_cacc = obj.S_CACC(v);
            s_acc = obj.S_ACC(v);
            s_idm = obj.S_IDM(v);
            s = (pc*pcc*s_cacc + pc*pch*s_acc + ph*s_idm);
        end
    end

end