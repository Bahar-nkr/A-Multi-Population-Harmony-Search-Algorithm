function x=improvisation_process (N,HMCR,PAR,bw,HM)

% for i=1:size
 x=[];
    for j=1:N
        r1=rand;
        if r1<HMCR
            x(1,j)= HM(ceil(rand*size(HM,1)),ceil(rand*size(HM,2)));
            r2=rand;
            if r2<PAR
                r3=rand;
                if r3<0.5
                    x(1,j)=x(1,j)+bw;
                else
                    x(1,j)=x(1,j)-bw;
                end
            else
                x(1,j)=x(1,j);
            end
        else
            x(1,j)=0+rand*(100-0);
        end
    end
    
% end