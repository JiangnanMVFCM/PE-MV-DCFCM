function RandIndex=computeRandIndex(U0, U)
% ����U0��U������RandIndex��ֵ
% U0��U��Ϊcxn����
% Last modified: 2009.07.06    19:22:00

[cluster_n0, data_n0] = size(U0);
[cluster_n, data_n] = size(U);

if (data_n0~=data_n)
    fprintf('RandIndex: �������С��ͬ\n');
    FMeasure = 0;
    return;
end

if cluster_n < cluster_n0
    zeroM = zeros(cluster_n0-cluster_n, data_n);
    U = [U; zeroM];
else
    if cluster_n > cluster_n0
        zeroM = zeros(cluster_n-cluster_n0, data_n);
        U0 = [U0; zeroM];
    end
end

mask = triu(ones(data_n0, data_n0))-eye(data_n0);
% ����M0
M0 = (U0'*U0).*mask;
% ����M
M = (U'*U).*mask;
% ����agreement
agreement = sum(sum((M0==M)))-data_n0*(data_n0+1)/2;
% ����RandIndex
RandIndex=2*agreement/(data_n0*(data_n0-1));