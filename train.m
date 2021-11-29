function [ B] = train(X, Y, param, L)

fprintf('training...\n');

%% set the parameters
nbits = param.nbits;
alphaX = param.lambdaX; 
alphaY = 1-alphaX;     
lambda = param.lambda;   
gamma = param.gamma;  
beide = param.beide;


%% get the dimensions
[n, dX] = size(X);
dY = size(Y,2);
[lx, ly] = size(L);

%% transpose the matrices
X = X'; Y = Y'; L = L';

%% initialization
V = randn(nbits, n);
G = randn(ly, nbits);


%% iterative optimization
for iter = 1:param.iter
    B = -1*ones(nbits,n);
    B((beide*V+lambda*G'*L)>=0) = 1;
    Ux = alphaX*(X*V')/(alphaX*(V*V')+gamma*eye(nbits));
    Uy = alphaY*(Y*V')/(alphaY*(V*V')+gamma*eye(nbits));
    G = lambda*(L*B')/(lambda*(B*B')+gamma*eye(nbits));
    V = (alphaX*(Ux'*Ux)+alphaY*(Uy'*Uy)+(beide+gamma)*eye(nbits))\(alphaX*(Ux'*X)+alphaY*(Uy'*Y)+beide*B);

end
return;
end

