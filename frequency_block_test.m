function p_value = frequency_block_test(key, bloco)
%     A distribuição de referência para este teste é o X²(chi-square)
    % key = [1 1 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 0 0 0 1 0 1 1 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 0 1 1 0 0 0 1 1 0 0 1 1 0 0 0 1 0 1 0 0 0 1 0 1 1 1 0 0 0];
    % bloco = 10;
    N = floor(length(key)/bloco);
    key(N*bloco+1:end) = [];
    key = reshape(key, [N, bloco]);
    proportion = sum(key)/bloco;
    chi_square = 4*bloco*sum((proportion - 0.5).^2);
    p_value = 1 - gammainc(chi_square/2, N/2);
        
    