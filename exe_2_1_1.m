clc;
clear;

% k is density
k_negetive = 0.1;
k_positive = 0.9;

syms k;
Qk = k*(1-k);
% f_Qkd(k) = diff(Qk)
f_Qkd(k) = Qk

Qkd_negetive = f_Qkd(k_negetive)
Qkd_positive = f_Qkd(k_positive)

lamda = double((Qkd_positive - Qkd_negetive) / (k_positive - k_negetive))

t = 0:0.1:1;
x = t * lamda;
% plot(x,t);

fill_pp = [];
fill_pm = [-1 1];
fill_pm = [[-1 0]; fill_pm];

for i = 1:length(x)
    fill_pm = [[x(i) t(i)]; fill_pm];
    fill_pp = [[x(i) t(i)]; fill_pp];
end
fill_pp = [fill_pp; [1 0]; [1 1]];
fill(fill_pm(:,1), fill_pm(:,2), 'blue');
hold on;
fill(fill_pp(:,1), fill_pp(:,2), 'yellow');


xlim([-1,1]);
ylim([0,1]);
xlabel('x');
ylabel('t');

figure(2);
[x, t] = meshgrid(-1:0.01:1, 0:0.01:1);

boundary = lamda * t;

z = zeros(size(x));
z(x < boundary) = 0.1; % 
z(x >= boundary) = 0.5; % 

surf(x, t, z, 'EdgeColor', 'none'); % 使用'EdgeColor'为'none'以去除网格线
colormap([0 0 1; ...
    1 1 0]);
xlabel('x');
ylabel('t');
zlabel('density');
