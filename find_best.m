function [bestset, fitness_temp,indexf] = find_best( fitness_temp)
  [fit,indexf]=sort(fitness_temp);
 
  bestset=fit(end);
  fitness_temp(indexf(end))=0;
  return  


end

