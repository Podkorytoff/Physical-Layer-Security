function key = msdQuant(X, alpha, M)

% Divide a informação em blocos menores, onde cada bloco será uma coluna em
% Xb:
N = length(X);
Xb = reshape(X, [M, N/M]);

% Inicializa vetor para armazenar bits das chaves:
key = zeros(M, N/M);

% Quantiza cada bloco:
for m = 1:N/M
    
    q_max = mean(Xb(:, m)) + alpha*std(Xb(:, m));
    q_min = mean(Xb(:, m)) - alpha*std(Xb(:, m));
    key(:, m) = keygenerator(q_max, q_min, Xb(:, m));
    
end

% Serializa os blocos para obter uma sequência de bits:
key = key(:);

end