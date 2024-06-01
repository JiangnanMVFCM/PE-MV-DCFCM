# Pseudo-label Enhanced Multi-view Deep Concept Factorization Fuzzy Clustering

This repository is the official implementation of *Pseudo-label Enhanced Multi-view Deep Concept Factorization Fuzzy Clustering*.

**Abstract:** Given the widespread availability of multi-view data in the real world, multi-view fuzzy c-means clustering (FCM) has garnered significant attention in recent years, leading to the development of various multi-view fuzzy clustering algorithms. However, existing algorithms still exhibit room for improvement. Firstly, most of existing algorithms only utilize the shallow information of the view data, and fail to delve into the mining and utilization of deeper representations. Secondly, existing algorithms tend to extract common representations among the views first, and then implement clustering separately, which may lack a collaborative linkage between representation learning and the clustering task. Lastly, multi-view clustering algorithms based on representation learning often overlook the importance of effectively preserving similarity information within the views. To address these limitations, we propose a novel algorithm called Pseudo-Label Enhanced Multi-View Deep Concept Factorization Fuzzy Clustering (PE-MV-DCFCM). The algorithm first introduces a deep concept factorization method to uncover the deep information of the view data. Subsequently, it employs pseudo-label learning to preserve intra-view similarity information during the learning of common representations among the views, based on non-negative matrix factorization (NMF). Finally, this algorithm integrates deep concept factorization, representation learning, and fuzzy clustering into a unified framework to enhance the collaboration among the various sub-steps of the algorithm. Experiments on several benchmark datasets show that the proposed PE-MV-DCFCM algorithm outperformed other state-of-the-art algorithms.

## Usage
We provide matlab code for the PE-MV-DCFCM algorithm, the core of the code is the `PE_MV_DCFCM` function. The user can run the algorithm through the *test_main.m* file. The important parameters in the code are as follows:
* **lans ($\lambda$):** regularisation parameter, balancing the learning of common representation among views.
* **delta ($\delta$):** regularisation parameter, balancing the impact of pseudo-label learning.
* **gammals ($\gamma$):** regularisation parameter, balance the importance of various views and reconcile their differences.

```
% test_main files

clc;
clear;

% route processing
addpath(genpath('./data/'));
addpath(genpath('./utils/'));

% Load data
load('BBC.mat');  

%% Hyperparameter setting
lans = 2.^(-4:4);
gamma1s = exp(-3:3);
delta = 10.^(-4:0);

......

```

## Datasets
Nine multi-view datasets are used in the paper to validate the PE-MV-DCFCM algorithm. These datasets include BBC, 20NewsGroups, 3Sources, Cora, MSRC, ORL, IS2, InternetAD, and Coil. Details of the datasets are described below:

| Datasets    | Number of samples | Number of features | Number of classes |
| :---------: | :---------: | :---------: | :---------:| 
| BBC         | 685         | 4(4659/4633/4665/4684)   | 5   | 
|20NewsGroups	|500	|3(2000/2000/2000)	|5|
|3Sources	|169	|3(3560/3631/3068)|	6|
|MSRC	|210|	4(210/256/512/1302)|	7|
|ORL	|400	|3(3304/4096/6750)	|40|
|IS2	|2310|	2(8/10)|	7|
|Cora	|2708|	2(1433/2708)|	7|
|InternetAD	|3279|	3(111/472/457)|	2|
|Coil|	3600	|3(1024/512/2560)|	100|

## Evaluation
In this paper, we evaluate the clustering performance using three indices: Accuracy (ACC), Normalized mutual information (NMI), and Purity, which are defined as follows:
### (1) Accuracy (ACC):
$$ACC = \frac{{\sum\limits_{i = 1}^N {\delta \left( {{s_i},map\left( {{r_i}} \right)} \right)} }}{N}$$

where $N$ is the number of samples, $s_i$ is the real label, and $r_i$ denotes the label obtained by the Kuhn-Munkres algorithm. $map(\cdot)$ is a mapping function that maps each cluster label to the equivalent label of the data. $\delta(x,y)$ is a 0-1 function: $\delta(x,y)=1$ if $x=y$, and 0 otherwise. $ACC\in[0,1]$ and the larger the value of ACC, the better the clustering performance of the model.

### (2) Normalized mutual information (NMI):

$$NMI = \frac{{\sum\limits_{i = 1}^C {\sum\limits_{j = 1}^C {{N_{i,j}}\log \frac{{N \times {N_{i,j}}}}{{{N_i} \times {N_j}}}} } }}{{\sqrt {\left( {\sum\limits_{i = 1}^C {{N_i}\log \frac{{{N_i}}}{N}} } \right) \times \left( {\sum\limits_{j = 1}^C {{N_j}\log \frac{{{N_j}}}{N}} } \right)} }}\$$

where $N_{i,j}$ denotes the number of samples of class $i$ that are classified into class $j$, $N_i$ denotes the number of samples contained in the $i$-th clustering cluster, and $N$ denotes the number of samples in the whole dataset. $NMI\in[0,1]$ and the larger the value of NMI, the better the clustering performance of the model.

### (3) Purity:

$$purity(\Omega ,C) = \frac{1}{N}\sum\limits_{k = 1}^K {\mathop {\max }\limits_{1 \le j \le J} } \left| {{\omega _k} \cap {{\rm{c}}_j}} \right|\$$

where $N$ is the number of samples in the whole dataset, $\Omega=\{\omega_1,\omega_2,\dots,\omega_k\}$ is the set of clusters contained by clustering, $C=\{c_1,c_2,\dots,c_j\}$ is the set of $j$ classes contained in the dataset, and represents the number of samples included in the intersection between the $k$ th cluster obtained by clustering and the $j$ th class in the dataset. $Purity \in [0,1]$ and the larger the value of Purity, the better the clustering performance of the model.

## Conclustion
To address several challenges posed by existing multi-view clustering methods, we propose a Pseudo-Label Enhanced Multi-View Deep Concept Factorization Fuzzy Clustering Algorithm (PE-MV-DCFCM). The algorithm first introduces deep concept factorization before representation learning to mine the deep information in the multi-view data and then introduces the pseudo-label learning mechanism in the NMF-based representation learning to improve learning quality. Finally, the method integrates deep concept factorization, representation learning, and FCM clustering into a unified framework, fostering better synergistic learning among the algorithm’s sub-steps. Experimental results demonstrate that the proposed PE-MV-DCFCM algorithm exhibits superior clustering performance compared with existing multi-view clustering algorithms. Ablation experiments and parameter sensitivity analyses further illustrate that the introduced deep concept factorization and pseudo-label learning methods effectively improve the performance of the multi-view clustering algorithm.
While the proposed algorithm has achieved some advances in addressing multi-view datasets, there remains room for improvement. The proposed PE-MV-DCFCM algorithm is able to mine the deep information in multi-view data well, but the algorithm currently does not account for the importance of factorization at each layer. Meanwhile, the FCM clustering based on the common representation does not consider the information of the differences between views, which may limit the final clustering results. Hence, our future research may focus on the following two aspects: one is to design an appropriate weight adjustment mechanism to improve the learning of common representations at each factorization layer, and the other is to introduce the effective mechanism for the exploitation of the difference information among views to further enhance the final clustering performance.
