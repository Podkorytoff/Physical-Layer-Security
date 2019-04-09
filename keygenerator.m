function key = keygenerator(threshold_max, threshold_min, X)
%Fun��o para gerar as chaves a partir da informa��o do canal
%Inputs:
%   Limites m�ximo e m�nimo
%   Vetor de informa��o do canal
%Outputs:
%   Chave

key = zeros(length(X), 1);

for i = 1:length(X)
    if X(i) > threshold_max
        key(i) = 1;
    elseif X(i) < threshold_min
        key(i) = 0;
    else
        key(i) = 5;
    end
end
