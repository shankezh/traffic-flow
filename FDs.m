clc;
clear;
close all;

% vf = 100;
% kj = 100;
% fun_q = @(k) vf*(k-k.^2/kj);
% 
% k = 1:100;
% 
% q = fun_q(k);
% 
% plot(k,q);

% m/s
vf = 33.3;
% length of vehicle body
l = 5;
% minimum safe distance
s0 = 2;

% desired headway
tc_cacc = 0.6;
tc_acc = 1.1;
tc_idm = 1.5;

% time lag
td_cacc = 0;
td_acc = 0.1;
td_idm = 0.4;
% platoon intensity
O = 0;
% percentage of CAVs
% pc = 0.5;
% ph = 1-pc;


% velocity
% v_list = [5.56, 8.33, 11.11, 13.89, 16.67, 19.44, 22.22, 25, 27.78, 30.56, 33.33];

% v = 0;   %20km/h
% v=30;
% pcc = mPI_C2C(ph, pc, O);
% pch = mPI_C2H(ph, pc, O);
% s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
% s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
% s_idm = S_IDM(16.67, tc_idm, td_idm, l, s0, vf)
% s_idm_hw = 33.33 * (tc_idm + td_idm) + l + s0

% fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
fq_list = [];
density_list = [];
spacing_list = [];
speed_list = [];
legend_list = [];

% title_list = ["speed vs density", "speed vs flow rate","density vs flow rate", "speed vs spacing"];

%% general figure
for pc = 0 :0.2: 1
    ph = 1 - pc;
    fq_list = [];
    density_list = [];
    spacing_list = [];
    speed_list = [];
    legend_list = [legend_list, "Pc="+pc];
    for v = 0 : 0.01: vf
        pcc = mPI_C2C(ph, pc, O);
        pch = mPI_C2H(ph, pc, O);
        phc = mPI_H2C(ph, pc, O);
        phh = mPI_H2H(ph, pc, O);
        s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
        s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
        s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);

        fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
        density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
        spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
        if spacing == inf
            disp([v,pc, s_idm])
        end
        speed_list = [speed_list, v];
        density_list = [density_list, density];
        spacing_list = [spacing_list, spacing];
        fq_list = [fq_list, fq];
    end
        figure(1);
        % speed-density
        subplot(2,2,1);
        plot(speed_list, density_list, "LineWidth",1.5,"LineStyle","-.");
        hold on;
        title("speed vs density");
        xlabel("velocity (m/s)");
        ylabel("density (vehs/km)");
        legend(legend_list);
        % speed-flow rate
        subplot(2,2,2);
        plot(speed_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title("speed vs flow rate");
        xlabel("velocity (m/s)");
        ylabel("flow rate (vehs/h)");
        legend(legend_list);
        hold on;
        subplot(2,2,3);
        plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title("density vs flow rate");
        xlabel("density (vehs/km)");
        ylabel("flow rate (vehs/h)");
        legend(legend_list);
        hold on;
        subplot(2,2,4);
        plot( spacing_list,speed_list, "LineWidth",1.5,"LineStyle","-.");
        title("spacing vs speed");
        xlabel("spacing (m)");
        ylabel("velocity (m/s)");
        legend(legend_list);
        hold on;
end

%% discuss influence of platoon intensity
count = 0;
% maximum different proportion of CAVs for different platoon intensity
max_f_pi = [];
max_d_pi = [];
for O = -1 :0.25 : 1
    count = count + 1;
    for pc = 0 : 0.2 : 1
        ph = 1 - pc;
        fq_list = [];
        density_list = [];
        spacing_list = [];
        speed_list = [];
        legend_list = [legend_list, "Pc="+pc];
        for v = 0: 0.01:vf
            pcc = mPI_C2C(ph, pc, O);
            pch = mPI_C2H(ph, pc, O);
            phc = mPI_H2C(ph, pc, O);
            phh = mPI_H2H(ph, pc, O);
            s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
            s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
            s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);

            fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
            density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            if spacing == inf
                disp([v,pc, s_idm])
            end
            speed_list = [speed_list, v];
            density_list = [density_list, density];
            spacing_list = [spacing_list, spacing];
            fq_list = [fq_list, fq];
            
        end
        % figure(2);
        % subplot(1,2,count);
        % plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        % title("density vs flow rate (O="+O+")");
        % xlabel("density (vehs/km)");
        % ylabel("flow rate (vehs/h)");
        % legend(legend_list);
        % hold on;
        if pc > 0 && pc < 1
            [fq_v, fq_idx] = max(fq_list);
            max_f_pi = [max_f_pi, fq_v];
            max_d_pi = [max_d_pi, density_list(fq_idx)];
        end
    end
end

%%
legend1_str = "Pc="+ ["0.2", "0.4", "0.6", "0.8"];
x_labels = linspace(-1,1,9);
for i = 1:4
    f_pi = [];
    d_pi = [];
    for j = 1:9
        f_pi = [f_pi, max_f_pi((j-1)*4+i)];
        d_pi = [d_pi, max_d_pi((j-1)*4+i)];
    end
    figure(3);
    subplot(1,2,1);
    plot(x_labels, f_pi, "--s");
    title("flow rate (O = [-1,1]; Pc = [0.2,0.4,0.6,0.8])");
    legend(legend1_str);
    xlabel("Platoon Intensity");
    ylabel("flow rate");
    hold on;
    set(gca, "XTick", x_labels);
    subplot(1,2,2);
    plot(x_labels, d_pi, "--s");
    title("density (O = [-1,1]; Pc = [0.2,0.4,0.6,0.8])");
    legend(legend1_str);
    xlabel("Platoon Intensity");
    ylabel("density");
    set(gca, "XTick", x_labels);
    hold on;
end

%% desire headways for CACC
tc_caccs = [0.6, 0.7, 0.9, 2.2];
tc_acc = 1.1;
tc_idm = 1.5;
O = 0;
pcs = [0.2, 0.4, 0.6, 0.8];
title_str = "Proportion of CAVs is ";
for i = 1:4
    pc = pcs(i);
    ph = 1-pc;
    legend_list = [];
    for tc_cacc = tc_caccs
        fq_list = [];
        density_list = [];
        spacing_list = [];
        speed_list = [];
        legend_list = [legend_list, "tc="+tc_cacc];
        for v = 0: 0.01:vf
            pcc = mPI_C2C(ph, pc, O);
            pch = mPI_C2H(ph, pc, O);
            phc = mPI_H2C(ph, pc, O);
            phh = mPI_H2H(ph, pc, O);
            s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
            s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
            s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);
    
            fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
            density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            if spacing == inf
                disp([v,pc, s_idm])
            end
            speed_list = [speed_list, v];
            density_list = [density_list, density];
            spacing_list = [spacing_list, spacing];
            fq_list = [fq_list, fq];
        end
        figure(4);
        subplot(2,2,i);
        plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title(title_str+pc);
        legend(legend_list);
        xlabel("density");
        ylabel("flow rate");
        hold on;
    end
end


%% desire headways for ACC
tc_cacc = 0.6;
tc_accs = [1.1, 1.6, 2.2];
tc_idm = 1.5;
O = 0;
pcs = [0.2, 0.4, 0.6, 0.8];
title_str = "Proportion of CAVs is ";
for i = 1:4
    pc = pcs(i);
    ph = 1-pc;
    legend_list = [];
    for tc_acc = tc_accs
        fq_list = [];
        density_list = [];
        spacing_list = [];
        speed_list = [];
        legend_list = [legend_list, "tc="+tc_acc];
        for v = 0: 0.01:vf
            pcc = mPI_C2C(ph, pc, O);
            pch = mPI_C2H(ph, pc, O);
            phc = mPI_H2C(ph, pc, O);
            phh = mPI_H2H(ph, pc, O);
            s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
            s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
            s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);
    
            fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
            density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            if spacing == inf
                disp([v,pc, s_idm])
            end
            speed_list = [speed_list, v];
            density_list = [density_list, density];
            spacing_list = [spacing_list, spacing];
            fq_list = [fq_list, fq];
        end
        figure(4);
        subplot(2,2,i);
        plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title(title_str+pc);
        legend(legend_list);
        xlabel("density");
        ylabel("flow rate");
        hold on;
    end
end

%% desire headways for IDM
tc_cacc = 0.6;
tc_acc = 1.1;
tc_idms = [1, 1.5, 2, 3];
O = 0;
pcs = [0.2, 0.4, 0.6, 0.8];
title_str = "Proportion of CAVs is ";
for i = 1:4
    pc = pcs(i);
    ph = 1-pc;
    legend_list = [];
    for tc_idm = tc_idms
        fq_list = [];
        density_list = [];
        spacing_list = [];
        speed_list = [];
        legend_list = [legend_list, "tc="+tc_idm];
        for v = 0: 0.01:vf
            pcc = mPI_C2C(ph, pc, O);
            pch = mPI_C2H(ph, pc, O);
            phc = mPI_H2C(ph, pc, O);
            phh = mPI_H2H(ph, pc, O);
            s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
            s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
            s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);
    
            fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
            density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            if spacing == inf
                disp([v,pc, s_idm])
            end
            speed_list = [speed_list, v];
            density_list = [density_list, density];
            spacing_list = [spacing_list, spacing];
            fq_list = [fq_list, fq];
        end
        figure(4);
        subplot(2,2,i);
        plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title(title_str+pc);
        legend(legend_list);
        xlabel("density");
        ylabel("flow rate");
        hold on;
    end
end


%% minimum safe distance
tc_cacc = 0.6;
tc_acc = 1.1;
tc_idm = 1.5;
O = 0;

s0s = [1, 1.3, 1.7, 2];
title_str = "S0=";
pc = 0.5;

legend_list = [];
for i = 1:4
    s0 = s0s(i);
    for pc = 0:0.2:1
        ph = 1-pc;
        fq_list = [];
        density_list = [];
        spacing_list = [];
        speed_list = [];
        legend_list = [legend_list, "Pc="+pc];
        for v = 0: 0.01:vf
            pcc = mPI_C2C(ph, pc, O);
            pch = mPI_C2H(ph, pc, O);
            phc = mPI_H2C(ph, pc, O);
            phh = mPI_H2H(ph, pc, O);
            s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
            s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
            s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);
    
            fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
            density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
            if spacing == inf
                disp([v,pc, s_idm])
            end
            speed_list = [speed_list, v];
            density_list = [density_list, density];
            spacing_list = [spacing_list, spacing];
            fq_list = [fq_list, fq];
        end
        figure(6);
        subplot(2,2,i);
        plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
        title(title_str+s0);
        legend(legend_list);
        xlabel("Density");
        ylabel("flow rate");
        hold on;
    end
end


%% time lags for IDM
tc_cacc = 0.6;
tc_acc = 1.1;
tc_idm = 1.5;
td_idms = [0, 0.1, 0.2, 0.3,0.4];
O = 0;
pcs = [0.2, 0.4, 0.6, 0.8];
title_str = "Proportion of CAVs is ";
pc = 0.5;
ph = 1-pc;
legend_list = [];
for td_idm = td_idms
    fq_list = [];
    density_list = [];
    spacing_list = [];
    speed_list = [];
    legend_list = [legend_list, "t="+td_idm];
    for v = 0: 0.01:vf
        pcc = mPI_C2C(ph, pc, O);
        pch = mPI_C2H(ph, pc, O);
        phc = mPI_H2C(ph, pc, O);
        phh = mPI_H2H(ph, pc, O);
        s_cacc = S_CACC(v, tc_cacc, td_cacc, l, s0);
        s_acc = S_ACC(v, tc_acc, td_acc, l, s0);
        s_idm = S_IDM(v, tc_idm, td_idm, l, s0, vf);

        fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm);
        density = 1000 / (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
        spacing = (pc*pcc*s_cacc + pc*pch*s_acc + ph*phc*s_idm + ph*phh*s_idm );
        if spacing == inf
            disp([v,pc, s_idm])
        end
        speed_list = [speed_list, v];
        density_list = [density_list, density];
        spacing_list = [spacing_list, spacing];
        fq_list = [fq_list, fq];
    end
    figure(5);
    plot(density_list, fq_list, "LineWidth",1.5,"LineStyle","-.");
    title("Influence of time lags");
    legend(legend_list);
    xlabel("density");
    ylabel("flow rate");
    hold on;
end



function mPlot(x,y,mTitle, mXlable, mYlabel, mLegend)
    plot(x,y);
    title(mTitle);
    xlabel(mXlable);
    ylabel(mYlabel);
    legend(mLegend);
    hold on;
end

% Platoon Intensity: CAV follows HDV
function possibilty = mPI_C2H(ph, pc, O)
    if O >= 0
        possibilty = ph * (1 - O);
    else
        possibilty = ph + O * (ph - min(1,ph/pc));
    end
end

% Platoon Intensity: HDV follows CAV
function possibilty = mPI_H2C(ph, pc, O)
    if O >= 0
        possibilty = pc * (1 - O);
    else
        possibilty = pc + O * (pc - min(1, pc/ph));
    end
end

% Platoon Intensity: CAV follows CAV
function possibility = mPI_C2C(ph, pc, O)
    possibility = 1 - mPI_C2H(ph, pc, O);
end


% Platoon Intensity: HDV follows HDV
function possibilty = mPI_H2H(ph, pc, O)
    possibilty = 1 - mPI_H2C(ph, pc, O);
end

function distance = S_CACC(v, tc, t, l, s0)
    distance = v * (tc + t) + l + s0;
end

function distance = S_ACC(v, tc, t, l, s0)
    distance = v * (tc + t) + l + s0;
end

function distance = S_IDM(v, tc, t, l, s0, vf)
    if v > 60
        distance = s0 + v*(tc + t) + l;
    else
        distance = (s0 + v*(tc + t)) / sqrt(1 - (v/vf)^4) + l;
    end
    
end

function fq = fundamental_diagram(v, pc, ph, pcc, pch, s_cacc, s_acc, s_idm)
    fq = (1000 * v * 3.6) / (pc*pcc*s_cacc + pc*pch*s_acc + ph*s_idm);
end