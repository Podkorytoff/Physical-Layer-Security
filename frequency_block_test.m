function p_value = frequency_block_test(key, bloco)
%     A distribuição de referência para este teste é o X²(chi-square)
%     key = [1 1 0 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0 0 0 1 0 0 0 1 0 0 0 0 1 0 1 1 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1 0 0 1 1 0 0 0 1 1 0 0 1 1 0 0 0 1 0 1 0 0 0 1 0 1 1 1 0 0 0];
%     bloco = 10;  
    N = length(key)/bloco;
    key = reshape(key, [bloco, N]);
    proportion = (sum(key)/bloco - 1/2).^2;
    chi_square = 4*bloco*sum(proportion);
    p_value = gammainc(N/2,chi_square/2);
        
    