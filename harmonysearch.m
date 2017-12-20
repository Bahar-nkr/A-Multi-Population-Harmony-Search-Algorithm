clc
clear all
close all

HMS=100;             % Harmony Memory Size
HMCR=0.6;            % Harmony Memory Consideration Rate
PAR=0.3;             % Pitch Adjustment Rate
bw=1;                % bandwidth
NI=500000;           % Number of Improvizations
N=5;                 % Number of Decision Variables

%random initialization for solutions.
HM=initialization(N,HMS,100,0);               % Harmony Memory

%Evaluation of solutions for the first time.
% fitness=evaluateF(HM);



for i=1:NI
    i
    %Checking allowable range.
    HM=space_bound(HM,100,0);
   
    
    
    %Evaluation of solutions.
    fitness=evaluateF(HM);
    
    
    [best best_HM]=max(fitness);
%     [worst worst_HM]=min(fitness);
    
    
    
    
hm1=HM(1:14,:);
hm2=HM(15:28,:);
hm3=HM(29:42,:);
hm4=HM(43:56,:);
hm5=HM(57:70,:);
hm6=HM(71:84,:);
hm7=HM(85,100,:);

% hm=[hm1;hm2; hm3; hm4; hm5; hm6; hm7];

% for l=1:7
    
    
   x=improvisation_process (NI,N,HMCR,PAR,bw,hm1);
   
   fit_x=evaluateF(x);
   fitness_1=evaluateF(hm1);
   [worst, worst_hm]=min(fitness_1);
   if fit_x> worst
       hm1(worst_hm,:)=x;
   end
   
   
    
    
    