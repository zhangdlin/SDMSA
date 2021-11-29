function [ Ktr1, Ktr2, Kte1, Kte2, Kanchor1, Kanchor2 ] = kernelTrans( I_tr, T_tr, I_te, T_te, anchorIndex )
%KERNELTRANS 此处显示有关此函数的摘要
% 输入：
%   I_tr, T_tr：训练集，N * d
%   I_te, T_te：测试集，n * d
%   anchorNum：锚点个数 m
% 输出：
%   Ktr1, Ktr2：训练集核矩阵，N * m
%   Kte1, Kte2：测试集核矩阵，n * m
%   Kanchor1,2：锚点核矩阵，m * m
%   anchorIndex：锚点随机序列
    
    n = size(I_tr, 1);
    
     % 随机 RBF 锚点
    anchor1 = I_tr(anchorIndex, :);
    anchor2 = T_tr(anchorIndex, :);

    % 计算带宽 σ^2
    z = I_tr * I_tr';
    z = repmat(diag(z), 1, n)  + repmat(diag(z)', n, 1) - 2 * z;
    sigma1 = mean(z(:));
    clear z;

    z = T_tr * T_tr';
    z = repmat(diag(z), 1, n)  + repmat(diag(z)', n, 1) - 2 * z;
    sigma2 = mean(z(:));
    clear z;

    % 计算核映射后矩阵
    Kanchor1 = kernelMatrix(anchor1, anchor1, sigma1);
    Kanchor2 = kernelMatrix(anchor2, anchor2, sigma2);
    Ktr1 = kernelMatrix(I_tr, anchor1, sigma1);
    Ktr2 = kernelMatrix(T_tr, anchor2, sigma2);
    Kte1 = kernelMatrix(I_te, anchor1, sigma1);
    Kte2 = kernelMatrix(T_te, anchor2, sigma2);

end

