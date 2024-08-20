clc;
clear;
ldfor = LDFormula();
ldfor.insert(0.1, "inf", 1);
ldfor.insert(0.9, 1, 2);
ldfor.insert(0.2, 2, 3);
ldfor.insert(0.4, 3, 4);
ldfor.insert(0.7, 4, 5);
ldfor.insert(0.9, 5, "inf");

ddd = copy(ldfor);
ddd.densities = [];