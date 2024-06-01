clc;
clear;

load(['mul_orl.mat']);  % 原始数据 n*1 cell  n*dim
%load(['bestH_ORL_50.mat']);
%data=reuter.data;
data=data'; %要有
%data=X';
%data = V1';
%labels=Y;
%labels=truelabel{1}';
lans=2.^(-3:14);
gamma1s =exp(-6:6);
delta= 10.^(-4:0);
k_cluster=length(unique(labels));
rs = [10];
%  for i=1:size(data,2)
%      data{i} =  data{i}';
% end
  option = [];
  option.maxIter = 200;
  option.minIter = 20;
  option.error = 1e-2;
  option.beta = 100;
  option.pi = zeros();
  option.PiFlag = 1;
  option.alpha = [1 1];
  option.NormWeight = 'NCW';
  layers = [100 50];
    for i=1:size(data,2)
       option.pi(i) = 1 / size(data,2);
        %X1{i} =normalize_data(data{i})';
        X2{i} = NormalizeData(data{i}',2);
    end
 X1=getDNMF(X2,option,layers);%Dim *N
for i=1:size(data,2)
       %X1{i} =normalize_data(data{i})';
       X1{i} = normalize_data(X1{i})';
        %X1{i} = X1{i}';
       %X2{i} = normalize_data(data{i}');
end
out_result_all=[];
bestNMI=0;
l=1;
for r =rs%[10:10:100]
    for lan =0.5%lans
        for gamma1 =exp(2)%gamma1s
            for delta1=0.1%delta
                for iter = 1:5
                    options.lan= lan;
                    options.gamma1 = gamma1;
                    options.r = r;
                    options.delta=delta1;
                    options.cluster_n= length(unique(labels));
                    tic;
                    [U,W,H,alfa] = MV_DPNMF( X1,X2,options); %X Dim * N  data N* Dim
                    t(iter) = toc;
                    [~,U1_index] = max(U);
                    N = size(data{1},1);
                   % result = bestMap(labels, U1_index');
                    %NMI(iter) = nmi(Y, result);
                    result1 = ClusteringMeasure(labels, U1_index'); 
                    [f,p,r1] = compute_f(labels,U1_index');                                   
                   % [A nmi avgent] = compute_nmi(gt,pred_label);
                    result1=[result1 f p r1];
                    ACC(iter)=result1(1);
                    NMI(iter)=result1(2);
                    Purity(iter) = result1(3);
                    ARI(iter)= result1(4);
                    F_score(iter) = result1(5);
                    precision(iter) = result1(6);
                    Recall(iter) = result1(7);
                    U0 = defuzzy(labels',N,options.cluster_n);
                    U1 = defuzzy( U1_index,N,options.cluster_n);
                    %ACC(iter) = length(find(Y == result))/length(Y);
                   % ACC(iter)=ACC2(Y,U1_index,options.cluster_n);
                    RI(iter)=computeRandIndex(U0 , U1);          
                    %Purity(iter) = result1(3);
                    %NMI(iter)=result1(2);
                    %NMI(iter)=computeNMI(U0 , U1);
                    %NMI(iter)=compute_nmi(U1_index' , Y);
                    %ARI(iter)=computeARI(vec2lab(U0'), vec2lab(U1'));             
                end
                out_result=[r,lan,gamma1,delta1,mean(ACC),std(ACC),mean(NMI),std(NMI),mean(RI),std(RI),mean(Purity),std(Purity),mean(ARI),std(ARI),mean(F_score),std(F_score),mean(precision),std(precision),mean(Recall),std(Recall)];
                out_result_all=[out_result_all ;out_result];
               
             if(mean(NMI) >bestNMI)
                  bestNMI= mean(NMI);
                  best_results.lan= lan;
                  best_results.gamma1 = gamma1;
                  best_results.r = r;
                  best_results.delta= delta1;
                  best_results.ACC_mean = mean(ACC);
                  best_results.ACC_std = std(ACC);
                  best_results.RI_mean = mean(RI);
                  best_results.RI_std = std(RI);
                  best_results.NMI_mean = mean(NMI);
                  best_results.NMI_std = std(NMI);
                  best_results.Purity_mean = mean(Purity);
                  best_results.Purity_std = std(Purity);
                  best_results.ARI_mean = mean(ARI);
                  best_results.ARI_std = std(ARI);
                  best_results.F_score_mean = mean(F_score);
                  best_results.F_score_std = std(F_score);
                  best_results.precision_mean = mean(precision);
                  best_results.precision_std = std(precision);
                  best_results.Recall_mean = mean(Recall);
                  best_results.Recall_std = std(Recall);
                  best_results.time = mean(t);
                  fprintf('\n. acc=%.4f,nmi=%.4f, RI=%4f,purity=%.4f, ARI=%.4f,F_score=%.4f,precision=%.4f,Recall=%.4f ...\n',  best_results.ACC_mean,  best_results.NMI_mean ,best_results.RI_mean,best_results.Purity_mean,best_results.ARI_mean,best_results.F_score_mean, best_results.precision_mean,best_results.Recall_mean);
              end 
          
%                 save(output_file, 'best_results');
%                 best_results
%             end
            end
        end
     end
end

%best_results.nmi = r_nmi;
%best_results.ari = r_ari;
%save(output_file, 'best_results');

