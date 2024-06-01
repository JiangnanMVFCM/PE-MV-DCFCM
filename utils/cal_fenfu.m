function [ fcn ] = cal_fenfu(K,W,XC,H,alfa)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
% u1 = U{1,1};
% u2 = U{2,1};
% mf1 = u1.^m; 
% dist1 = distfcm(V, (W{1,1}'*X1')');       % fill the distance matrix
% obj_fcn1 = sum(sum((dist1.^2).*mf1));
% mf2 = u2.^m;
% dist2 = distfcm(V,(W{2,1}'*X2')');       % fill the distance matrix
% obj_fcn2 = sum(sum((dist2.^2).*mf2));
% fcn = obj_fcn1 + obj_fcn2;
fcn =0;
N = size(XC{1,1},2);
for k=1:K
%     fcn = fcn + alfa(k)* norm((V_weight{k,1}'*ones(1,N)).*XC{k,1} - (V_weight{k,1}'*ones(1,N)).*(W{k,1}*H), 'fro')^2;
     fcn = fcn + alfa(k)*norm(XC{k,1} - W{k,1}*H, 'fro')^2;
end
end

