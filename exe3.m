clc;
clear;

vf = 108;
wb = 20;
qm = 2160;
kj = 138;
cell_length = 0.15;
delta_t = 5/3600;

aa = MCTM();
aa.init(vf, wb, qm,kj,delta_t,cell_length);
[n,k,v,q] = aa.mainRoad(4,4,5)

C = aa.mergeRoad(2 , {2,2}, {2,1})
D = aa.divisionRoad(5, {5, 2}, {2,1})