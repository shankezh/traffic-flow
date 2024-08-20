clc;
clear;
% 定义多边形的顶点
left_top_x = 1; left_bot_x = 1;
right_bot_x = 4; right_top_x = 4;
left_top_y = 4; left_bot_y = 1;
right_bot_y = 1; right_top_y = 4;

% 定义多边形的x和y坐标
x = [left_top_x, left_bot_x, right_bot_x, right_top_x];
y = [left_top_y, left_bot_y, right_bot_y, right_top_y];

% 生成meshgrid
[sx, sy] = meshgrid(0:0.1:5, 0:0.1:5);

% 初始化sz
sz = zeros(size(sx));

% 确定哪些点位于多边形内
in = inpolygon(sx, sy, x, y);

% 将位于多边形内的点的sz值设置为1
sz(in) = 1;

% 绘制结果
figure;
surf(sx, sy, sz);
% shading interp;
title('Points within the Polygon Set to 1');
xlabel('X');
ylabel('Y');
zlabel('Z');