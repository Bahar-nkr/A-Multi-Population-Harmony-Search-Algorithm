clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%
% set parameters:

HMS=100;
HMCR=0.6;
PAR=0.3;
bw=1;
NI=100;
N=5;
Num_peaks=5;
Nrun=5;

%%%%%%%%%%%%%%%%%%%%%%%%
% initialization

HM=initialization(N,HMS,100,0);
H=initialization(Num_peaks,1,70,30);
W=initialization(Num_peaks,1,12,1);
v=initialization(N,Num_peaks,1,0);
X=initialization(N,Num_peaks,100,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%

Ext_Archive=HM;

for r=1:Nrun
    r
    
    fitness_1=evaluateF(HM,Num_peaks,N,X,H,W);
    best=max(fitness_1);
    
    for i=1:NI
        %         i
        for u=1:Num_peaks
            rand_1=rand(1,5);
            updated_H(1,u)=H(1,u)+(7.*normrnd(0,1,1));
            if updated_H(1,u)>70
                updated_H(1,u)=70;
            elseif updated_H(1,u)<30
                updated_H(1,u)=30;
            end
            updated_W(1,u)=W(1,u)+(1*normrnd(0,1,1));
            if updated_W(1,u)>12
                updated_W(1,u)=12;
            elseif updated_W(1,u)<1
                updated_W(1,u)=1;
            end
            updated_v(u,:)=rand_1./(rand_1+v(u,:));
            updated_X(u,:)=X(u,:)+updated_v(u,:);
            
        end
        
        H=updated_H;
        W=updated_W;
        v=updated_v;
        X=updated_X;
        
        
        
        HM_first=HM;
        
%         fitness_1=evaluateF(HM,Num_peaks,N,X,H,W);
%         best(1,i)=max(fitness_1);
        if i==1
            F_best(1,1)=best;
            
            
        elseif H_best(1,i-1)>=F_best(1,i-1)  %maximization
            F_best(1,i)=H_best(1,i-1);
        elseif H_best(1,i-1)<F_best(1,i-1)
            F_best(1,i)=F_best(1,i-1);
            
        end
        
        %         S(1,i)=H_best(1,i)-F_best(1,i)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  The entire population is divided into several sub-populations
        %  based on the quality of solutions.
%         hm=cell(1,7);
%         for k=1:7
%             
%             fitness=evaluateF(HM_first,Num_peaks,N,X,H,W);
%             [optimum, index_optimum]=max(fitness);
%             
%             y=HM_first(index_optimum,:);
%             HM_first(index_optimum,:)=[];
%             
%             for j=1:size(HM_first,1)
%                 
%                 d(1,j)=sum((y-HM_first(j,:)).^2);
%             end
%             
%             %         hm=cell(1,7);
%             hm{1,k}=y;
%             
%             for a=1:13
%                 
%                 [min, index_min]=min_func(d);
%                 hm{1,k}=[hm{1,k}; HM_first(index_min,:)];
%                 
%                 HM_first(index_min,:)=[];
%                 d(index_min)=[];
%                 
%                 
%             end
%             d=0;
%         end
%         
%         hm{1,7}=[hm{1,7}; HM_first];



 hm=cell(1,7);
        s=0;m=1;p=14;
        y=1;q=0;
       for k=1:7
           if k==7
                hm{1,7}=HM(s*p+m:end,:);
           else
        hm{1,k}=HM(s*p+m:s*p+m+p,:);
           end
           s=s+1;m=m+1;
       end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for b=1:7
            
            
            
            for z=1:size(hm{1,b},1)
                
                fitness_first=evaluateF(hm{1,b},Num_peaks,N,X,H,W);
            [worst_first, index_worst_first]=min(fitness_first);
            [best_first, index_best_first]=max(fitness_first);
                
                % generated a new harmony solution
                x=improvisation_process (N,HMCR,PAR,bw,hm{1,b});
                
                % updating the hm
                fit_x=evaluateF(x,Num_peaks,N,X,H,W);
                
                if fit_x > worst_first
                    hm{1,b}(index_worst_first,:)=x;
                end
                
                % updating the Ext_Archive
                fitness_Archive=evaluateF(Ext_Archive,Num_peaks,N,X,H,W);
                [worst_Archive, index_worst_Archive]=min(fitness_Archive);
                
                if fit_x > worst_Archive
                    Ext_Archive(index_worst_Archive,:)=x;
                end
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%
                % change detection
                
                fitness_second=evaluateF(hm{1,b},Num_peaks,N,X,H,W);
                [best_second, index_best_second]=max(fitness_second);
                q=0;
                if best_first~=best_second
                    q=1;
                    break
                    
                else
                    
                    continue
                end
                
                
            end
            
            if q==1;
                break
            else
                continue
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % merging all the sub-populations
        
        HM=[hm{1,1};hm{1,2};hm{1,3};hm{1,4};hm{1,5};hm{1,6};hm{1,7}];
        
        %         fitness_2=evaluateF(HM,Num_peaks,N,X,H,W);
        %         H_best=max(fitness_2);
        %
        %         S(1,i)=H_best-F_best
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % find correlation between solutions and find redundant solutions
        
        R=corrcoef(HM');
        R=triu(R);
        
        [row, column]=find(R>0.7);
        
        row=row';
        column=column';
        
        length_row=length(row);
        
        % the solutions are stored in the external archive will replace
        % the redundant solutions in the population.
        
        fitness_temp=evaluateF(Ext_Archive,Num_peaks,N,X,H,W);
        for p=1:length_row
            
% % %             if row(1,p)~=column(1,p)
% % %                 
% % %                 HM(row(1,p),:)=Ext_Archive(ceil(rand*size(Ext_Archive,1)),:);
% % %             end
            
if row(1,p)~=column(1,p) && row(1,p)~=0
               [ bestset, fitness_temp,indexf]= find_best(fitness_temp);
               
               HM(row(1,p),:)=Ext_Archive(indexf(end),:);
              yy= row(1,p);
              [tr,c]=find(row==yy);
              for s=1:length(c)
                  vv=c(s);
                  row(vv)=0;
              end
              length_row=length(row);
end

        end
        
        fitness_2=evaluateF(HM,Num_peaks,N,X,H,W);
        H_best(1,i)=max(fitness_2);
        %
        %         S(1,i)=H_best-F_best
        
        %         for u=1:Num_peaks
        %
        %             updated_H(1,u)=H(1,u)+(7.*normrnd(0,1,1));
        %             updated_W(1,u)=W(1,u)+(1*normrnd(0,1,1));
        %             updated_v(u,:)=rand(1,5)./(rand(1,5)+v(u,:));
        %             updated_X(u,:)=X(u,:)+updated_v(u,:);
        %
        %         end
        %
        %         H=updated_H;
        %         W=updated_W;
        %         v=updated_v;
        %         X=updated_X;
        
    end
    
    S=F_best-H_best
    %     offline_error(1,r)=(1/NI)*sum(S)
    
    offline_error(1,r)=mean(S)
    
    
end

ave_offline_error=mean(offline_error)












