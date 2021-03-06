function key = msdQuant(X, alpha, M)

% Divide a informa��o em blocos menores, onde cada bloco ser� uma coluna em
% Xb:
N = length(X);
Nb = floor(N/M);
X(Nb*M+1:end) = [];
Xb = reshape(X, [M, Nb]);

% Inicializa vetor para armazenar bits das chaves:
key = zeros(M, Nb);

% Quantiza cada bloco:
for m = 1:N/M
    
    q_max = mean(Xb(:, m)) + alpha*std(Xb(:, m));
    q_min = mean(Xb(:, m)) - alpha*std(Xb(:, m));
    key(:, m) = keygenerator(q_max, q_min, Xb(:, m));
    
end

% Serializa os blocos para obter uma sequ�ncia de bits:
key = key(:);

end