function [obj ] = total_value( U,H,V,expo,K,W,X,alfa,lan,Y,Q,delta,gamma1)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

fcn =0;
mf = U.^expo;       % MF matrix after exponential modification
center = V';
% center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % new center
dist = distfcm(center, H');  
obj_fcn = sum(sum((dist.^2).*mf));
N = size(X{1},2);
for k=1:K
%     fcn = fcn + alfa(k)* norm((V_weight{k,1}'*ones(1,N)).*XC{k,1} - (V_weight{k,1}'*ones(1,N)).*(W{k,1}*H), 'fro')^2;
%      fcn = fcn + (alfa(k)*norm(XC{k,1} - W{k,1}*H, 'fro')^2)+gamma*alfa(k)*log(alfa(k));
 obj1 = lan*(alfa(k)*norm(X{k} - W{k}*H, 'fro')^2);
 obj2 = gamma1*alfa(k)*log(alfa(k));
 obj3 = delta*alfa(k)*norm(Y{k} - Q{k}*H, 'fro')^2;
 fcn = fcn +obj1+obj2+obj3;
end
obj = obj_fcn + fcn;
end


