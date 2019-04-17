function p_value = frequency_block_test(key, bloco)
%     A distribui��o de refer�ncia para este teste � o X�(chi-square)
    % key = [1 1 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 0 0 0 1 0 1 1 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 0 1 1 0 0 0 1 1 0 0 1 1 0 0 0 1 0 1 0 0 0 1 0 1 1 1 0 0 0];
    % bloco = 10;
    N = floor(length(key)/bloco);
    key(N*bloco+1:end) = [];
    key = reshape(key, [N, bloco]);
    proportion = (sum(key)/bloco - 1/2).^2;
    chi_square = 4*bloco*sum(proportion);
    p_value = 1 - gammainc(chi_square/2,N/2);
        
    