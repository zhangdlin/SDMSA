function [ W ] = SAE(X, S, alph)

A = alph*S*S';
B = X*X';
C = (1 + alph) * S*X';
W = sylvester(A,B,C);


end

