% % 创建一个图形窗口
% figure;
% hold on;
% 
% % 定义每个矩形的顶点坐标和密度值
% rectangles = {
%     [0, 0, 1, 1], 0.1; % 第一个矩形
%     [1, 0, 2, 1], 0.35; % 第二个矩形
%     [0, 1, 1, 2], 1.2; % 第三个矩形
%     [1, 1, 2, 2], 0.9; % 第四个矩形
% };
% 
% % 绘制每个矩形并应用颜色
% for i = 1:size(rectangles, 1)
%     vertices = rectangles{i, 1};
%     density = rectangles{i, 2};
%     color = getColorByDensity(density);
% 
%     % 定义矩形的顶点
%     x = [vertices(1), vertices(3), vertices(3), vertices(1)];
%     y = [vertices(2), vertices(2), vertices(4), vertices(4)];
% 
%     % 使用fill函数绘制矩形并填充颜色
%     fill(x, y, color);
% end
% 
% % 设置轴范围
% axis([0 2 0 2]);
% title('填充图形使用颜色映射');
% hold off;


% 定义颜色映射函数
function color = getColorByDensity(density)
    % 定义颜色 r g  b
    % 1-> 250, 250, 20
    % 0-> 0 , 0 , 250
    %61 38 136

    % r = abs(255 *  cos(pi * density));
    % r = 255 * density;
    % g = 255 * density;
    % b = 255 * (1-density);
    % color = [r, g, b] / 255;

    cmap = colormap("default"); % parula

    % Number of colors in the colormap
    numColors = size(cmap, 1);

    % Find the corresponding color index
    colorIndex = round(density * (numColors - 1)) + 1;

    % Get the color from the colormap
    color = cmap(colorIndex, :);


end

