%This function initializes the position of the solutionss in the search space, randomly.

function [X]=initialization(dim,N,up,down)


    X=rand(N,dim).*(up-down)+down;
end