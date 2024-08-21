function [n,k,v] = MKRONOS(cell_length, a_n_last, c_n_last, a2b_last, c2d_last, a_in_last, c_in_last, vf, kj)
    n = (a_n_last + c_n_last)/2 - (a2b_last + c2d_last)/2 + (a_in_last + c_in_last)/2;
    k = n/cell_length;
    % using greenshield
    v = vf * (1 - k / kj);
end