%This function Evaluates the solutions. 


function   fitness=evaluateF(HM,Num_peaks,N,X,H,W)

for i=1:size(HM,1)
    for k=1:Num_peaks
        for j=1:N
            sol(1,j)=(HM(i,j)-X(k,j))^2;
        end
        ans(1,k)=H(1,k)/(1+W(1,k)*(sum(sol)));
        
    end
    
    fitness(i)=max(ans);
end