classdef MCTM <handle
    properties
        vf  % free speed : wf
        vc  % conjested speed wb
        qm  % maximum flow rate
        delta_t
        kj
        cell_length
        delta_x
    end
    methods
        function obj = init(obj, wf, wb, qm, kj, t, cell_length)
            obj.vf = wf;
            obj.vc = wb;
            obj.qm = qm;
            obj.kj = kj;
            obj.delta_t = t;
            obj.cell_length = cell_length;
        end

        function [n, k, v, q] = mainRoad(obj, a_n_last, b_n_last, c_n_last)
            obj.delta_x = obj.vf * obj.delta_t;
            
            yb = min(min(a_n_last, obj.qm*obj.delta_t), (obj.vc/obj.vf)*(obj.kj*obj.delta_x-b_n_last));
            yc = min(min(b_n_last, obj.qm*obj.delta_t), (obj.vc/obj.vf)*(obj.kj*obj.delta_x-c_n_last));
            
            n = b_n_last + yb - yc;
            
            k = n / obj.cell_length;
            % using greenshields

            % qfree is q for free speed
            q_free = obj.kj * obj.vc;
            % q for conjestion state
            q_conjestion = q_free * (1 - k/obj.kj);

            % q for unconjestion state
            q_unconjestion = k * obj.vf;

            % get real flow rate q
            q = min(min(q_unconjestion, obj.qm), q_conjestion);

            v = q / k;
        end

        % Cin , Cell for flow in
        % Pin , Priority for flow in
        function Cn = mergeRoad(obj, accept_n, Cin, Pin)
            Cn = {};
            % get cell lenght
            cl = length(Cin);
            if cl < 2
                disp("error input!");
                Cn = 0;
                return
            end
            nIn = 0;    % flow in totally number
            nPin = 0;    % flow in all priority number
            for i = 1 : cl
                nIn = nIn + Cin{i};
                nPin = nPin + Pin{i};
            end

            % offer less than requir
            if nIn <= accept_n
                Cn = Cin;
            end
            
            % offer more than requir
            if nIn > accept_n
                for i = 1 : cl-1
                    t1 = Cin{i};
                    t2 = accept_n - Cin{i+1};
                    t3 = accept_n * (Pin{i} / nPin);
                    Cn{i} = median([t1, t2, t3]);
                    t4 = Cin{i+1};
                    t5 = accept_n - Cin{i};
                    t6 = accept_n * (Pin{i+1} / nPin);
                    Cn{i+1} = median([t4, t5, t6]);
                end
            end

        end
        
        function Cn = divisionRoad(obj, offer_n, Rin, Pin)
            Cn = {};
            % get cell lenght
            cl = length(Rin);
            if cl < 2
                disp("error input!");
                Cn = 0;
                return
            end
            nIn = 0;    % flow in totally number
            nPin = 0;    % flow in all priority number
            for i = 1 : cl
                nIn = nIn + Rin{i};
                nPin = nPin + Pin{i};
            end
            
            COffer_n = {offer_n};
            for i = 1:cl
                COffer_n{i + 1} = Rin{i} / (Pin{i} / nPin);
                disp((Pin{i} / nPin))
            end
            % get specific number for realistic vehicles
            nOffer = min(cell2mat(COffer_n));
            
            for i = 1:cl
                Cn{i} = nOffer * (Pin{i} / nPin);
            end
            
        end
    end

end