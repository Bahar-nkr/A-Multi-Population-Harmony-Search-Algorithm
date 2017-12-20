%This function find the  function value of a candidate solutions. 


function   fitness=function_value(HM,Num_peaks,N,X,H,W)

for i=1:size(HM,1)
    for k=1:Num_peaks
        for j=1:N
            sol(1,j)=(HM(i,j)-X(k,j))^2;
        end
        ans(1,k)=H(1,k)-W(1,k)*sqrt(sum(sol));
        
    end
    
    fitness(i)=max(ans);
end