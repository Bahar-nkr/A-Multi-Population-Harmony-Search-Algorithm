%This function checks the search space boundaries for solutions.
function  HM=space_bound(HM,up,low)

[N,dim]=size(HM);
for i=1:N 
     Tp=HM(i,:)>up;Tm=HM(i,:)<low;HM(i,:)=(HM(i,:).*(~(Tp+Tm)))+up.*Tp+low.*Tm;

end