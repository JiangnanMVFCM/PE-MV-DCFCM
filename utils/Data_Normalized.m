function a = Data_Normalized(a)
[m,n]= size(a);
for i = 1: n
    amax = max(a(:,i));  %������������
    amin = min(a(:,i));  %���������С��
    for j = 1: m
       a(j,i)= (a(j,i)-amin)/(amax-amin);      
    end
end
% a(find(isnan(a)==1)) = 1;

