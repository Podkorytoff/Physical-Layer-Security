function p_value = frequency_block_test(key, bloco)
%     A distribui��o de refer�ncia para este teste � o X�(chi-square)
%     key = [1 1 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 0 0 0 1 0 1 1 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 0 1 1 0 0 0 1 1 0 0 1 1 0 0 0 1 0 1 0 0 0 1 0 1 1 1 0 0 0];
%     bloco = 10;  
    N = length(key)/bloco;
    key = reshape(key, [bloco, N]);
    proportion = (sum(key)/bloco - 1/2).^2;
    chi_square = 4*bloco*sum(proportion);
    p_value = gammainc(N/2,chi_square/2);
        
    